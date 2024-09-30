import 'dart:io';
import 'package:dev_studio/client/web_compiler.dart';

void main() {
  buildWebBundle('test/widget_scenario.dart',
      flutter: FlutterSdk.current,
      destination: 'build/scenario/widgets',
      appName: 'Widgets',
      rootPackageDirectory: Directory.current);
}
