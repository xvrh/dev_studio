import 'dart:io';
import 'package:stream_channel/stream_channel.dart';
import '../../../scenario.dart';
import 'asset_bundle.dart';
import 'asset_bundle_io.dart';
import 'setup.dart' show BundleParameters;

Future<ScenarioBundle> createBundle(BundleParameters params) async {
  return IOAssetBundle(
    'build/flutter_assets',
    bundleParams: params,
  );
}

String get currentDirectory => Directory.current.absolute.path;

const environmentWebSocket = 'scenario-server-url';

StreamChannel<String> createChannel() {
  var serverUrl = const String.fromEnvironment(environmentWebSocket,
      defaultValue: '0.0.0.0:$defaultServerPort');

  return connectToServer(Uri.parse('ws://$serverUrl/socket'));
}

void onConnected() {
  // Not used in io mode
}
