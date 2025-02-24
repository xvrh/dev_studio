import 'dart:io';
import 'package:dev_studio/core/flutter_sdk.dart';
import 'package:logging/logging.dart';
import 'package:process_runner/process_runner.dart';
import 'package:stream_channel/stream_channel.dart';
import '../../../scenario.dart';
import 'asset_bundle.dart';
import 'asset_bundle_io.dart';
import 'setup.dart' show BundleParameters;

final _logger = Logger('setup_io');

Future<ScenarioBundle> createBundle(BundleParameters params) async {
  try {
    await _buildBundle(FlutterSdk.current);
  } catch (e, s) {
    _logger.info('Failed to run flutter build bundle', e, s);
  }

  return IOAssetBundle('build/flutter_assets', bundleParams: params);
}

String get currentDirectory => Directory.current.absolute.path;

const environmentWebSocket = 'scenario-server-url';

StreamChannel<String> createChannel() {
  var serverUrl = const String.fromEnvironment(
    environmentWebSocket,
    defaultValue: '0.0.0.0:$defaultServerPort',
  );

  return connectToServer(Uri.parse('ws://$serverUrl/socket'));
}

void onConnected() {
  // Not used in io mode
}

Future<void> _buildBundle(FlutterSdk sdk) async {
  var emptyFile =
      File('lib/__empty__.dart')
        ..createSync()
        ..writeAsStringSync('void main() {}');

  var processRunner = ProcessRunner(printOutputDefault: false);

  try {
    await processRunner.runProcess([
      sdk.flutter,
      'build',
      'bundle',
      '--release',
      emptyFile.path,
    ]);
  } finally {
    emptyFile.deleteSync();
  }
}
