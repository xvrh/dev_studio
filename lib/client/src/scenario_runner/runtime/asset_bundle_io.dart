import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as path;
import '../../utils/fake_http_client.dart';
import 'asset_bundle.dart';
import 'setup.dart' show BundleParameters;

class IOAssetBundle extends CachingAssetBundle implements ScenarioBundle {
  final String assetFolderPath;
  final BundleParameters bundleParams;
  final realHttpClient = Client();

  IOAssetBundle(this.assetFolderPath, {required this.bundleParams});

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    var packageName = bundleParams.projectPackageName;
    var data = await load(key);
    var string = utf8.decode(data.buffer.asUint8List());
    if (key == 'FontManifest.json' && packageName != null) {
      string = string.replaceAll('packages/$packageName/', '');
    }
    return string;
  }

  @override
  Future<ByteData> load(String key) async {
    var projectRoot = bundleParams.rootProjectPath;
    File asset;
    if (projectRoot != null && key.startsWith('assets/')) {
      asset = File(path.join(projectRoot, key));
    } else {
      asset = File(path.join(assetFolderPath, key));
    }

    var encoded = Uint8List.fromList(asset.readAsBytesSync());
    return Future.value(encoded.buffer.asByteData());
  }

  @override
  Future<void> waitFinishLoading() async {
    for (var request in _requestCompleters) {
      try {
        var realResponse = await realHttpClient.readBytes(request.request.uri);
        request.response.complete(
            FakeHttpResponse(statusCode: HttpStatus.ok, body: realResponse));
      } catch (e) {
        request.response
            .complete(FakeHttpResponse(statusCode: HttpStatus.notFound));
      }
    }
    _requestCompleters.clear();
  }

  @override
  Future<void> runWithNetworkOverride(Future<void> Function() callback) async {
    await HttpOverrides.runZoned(() async {
      await callback();
    }, createHttpClient: (_) => _createFakeHttpClient());
  }

  final _requestCompleters = <_RequestCompleter>[];
  HttpClient _createFakeHttpClient() {
    return FakeHttpClient((request, client) async {
      print('Network request: ${request.uri}');

      //TODO(xha): find an alternative:
      // - always mock network request with pre-cached images
      // - always return an empty image?

      var requestCompleter = _RequestCompleter(request);
      _requestCompleters.add(requestCompleter);

      return requestCompleter.response.future;
    });
  }
}

class _RequestCompleter {
  final HttpClientRequest request;
  final response = Completer<FakeHttpResponse>();

  _RequestCompleter(this.request);
}
