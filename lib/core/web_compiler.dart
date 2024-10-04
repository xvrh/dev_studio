import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:process_runner/process_runner.dart';
import 'package:yaml/yaml.dart';
import 'src/web_manifest.dart';

export 'src/web_manifest.dart'
    show WebManifest, ManifestEntry, BuildInfo, RelatedProject;

Future<void> buildWebBundle(
  String clientEntryPoint, {
  required String appEntryPoint,
  required FlutterSdk flutter,
  required String destination,
  required String appName,
  required Directory rootPackageDirectory,
  String? rootPackageName,
  List<RelatedProject>? relatedProjects,
  String? manifestPath = '../manifest.json',
}) async {
  var destinationDir = Directory(destination);
  if (!destinationDir.existsSync()) {
    destinationDir.createSync(recursive: true);
  }

  var processRunner = ProcessRunner(printOutputDefault: true);
  await processRunner.runProcess([flutter.flutter, 'pub', 'get']);

  await _buildScenarioApp(
    destinationDir,
    appEntryPoint: appEntryPoint,
    flutter: flutter,
    appName: appName,
    rootPackageDirectory: rootPackageDirectory,
    relatedProjects: relatedProjects ?? [],
    manifestPath: manifestPath,
  );

  await processRunner.runProcess([
    flutter.flutter,
    'build',
    'web',
    '--release',
    '--web-renderer',
    'canvaskit',
    '--target',
    clientEntryPoint,
  ]);

  var clientOutput = Directory(p.join(destinationDir.path, 'client'));
  _copyDirectory(Directory('build/web'), clientOutput);
  var favicon = File('build/web/favicon.png');
  if (favicon.existsSync()) {
    favicon.copySync(p.join(destinationDir.path, 'favicon.png'));
  }

  if (rootPackageName != null) {
    var rootPackageAsset = Directory(
        p.join(clientOutput.path, 'assets/packages/$rootPackageName'));
    _copyDirectory(
        rootPackageAsset, Directory(p.join(clientOutput.path, 'assets')));
  }
}

Future<void> _buildScenarioApp(
  Directory destination, {
  required String appEntryPoint,
  required FlutterSdk flutter,
  required String appName,
  required Directory rootPackageDirectory,
  required List<RelatedProject> relatedProjects,
  required String? manifestPath,
}) async {
  var processRunner = ProcessRunner(printOutputDefault: true);
  await processRunner.runProcess([flutter.flutter, 'pub', 'get']);
  await processRunner.runProcess([
    flutter.flutter,
    'build',
    'web',
    '--release',
    '--web-renderer',
    'canvaskit',
    '--target',
    appEntryPoint,
  ]);

  _copyDirectory(Directory('build/web'), destination);

  var buildInfo = BuildInfo(
    ManifestEntry(
      buildNumber: '',
      version: projectVersion(rootPackageDirectory),
      date: DateTime.now().toUtc(),
      url: '',
    ),
    manifestPath: manifestPath,
    relatedProjects: relatedProjects,
  );

  File(p.join(destination.path, 'index.html')).writeAsStringSync(
      htmlEntryPoint(appName: appName, basePath: '', buildInfo: buildInfo));
}

void _copyDirectory(Directory source, Directory destination) {
  for (var entity in source.listSync(recursive: false)) {
    if (entity is Directory) {
      var newDirectory =
          Directory(p.join(destination.absolute.path, p.basename(entity.path)));
      newDirectory.createSync(recursive: true);

      _copyDirectory(entity.absolute, newDirectory);
    } else if (entity is File) {
      var destPath = p.join(destination.path, p.basename(entity.path));
      File(destPath).parent.createSync(recursive: true);
      entity.copySync(destPath);
    }
  }
}

String projectVersion(Directory directory) {
  var pubspec = File(p.join(directory.path, 'pubspec.yaml'));
  var pubspecYaml = loadYaml(pubspec.readAsStringSync()) as YamlMap;
  var version = pubspecYaml['version'] as String;
  return version.split('+').first;
}

String htmlEntryPoint({
  required String appName,
  required String basePath,
  required BuildInfo buildInfo,
}) {
  var basePathHref = '';
  if (basePath.isNotEmpty) {
    basePathHref = '$basePath${basePath.endsWith('/') ? '' : '/'}';
  }
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>$appName</title>
  <base href="$basePathHref">
  <link rel="shortcut icon" type="image/png" href="${p.url.join(basePath, 'favicon.png')}"/>
</head>
<body build-info="${buildInfo.toHtmlAttribute()}">
  <script src="${p.url.join(basePath, 'main.dart.js')}"></script>
</body>
</html>  
''';
}

class FlutterSdk {
  final String root;

  FlutterSdk(String path) : root = p.canonicalize(path);

  static FlutterSdk get current {
    var sdk = tryFind(Platform.resolvedExecutable);
    if (sdk != null) {
      return sdk;
    }
    throw StateError('Flutter SDK not found. Dart executable: '
        '${Platform.resolvedExecutable}');
  }

  static FlutterSdk? tryFind(String path) {
    if (FileSystemEntity.isDirectorySync(path)) {
      var dir = Directory(path);
      while (dir.existsSync()) {
        var sdk = FlutterSdk(dir.path);
        if (isValid(sdk)) {
          return sdk;
        } else {
          var parent = dir.parent;
          if (parent.path == dir.path) return null;
          dir = parent;
        }
      }
    } else if (FileSystemEntity.isFileSync(path)) {
      return tryFind(File(path).parent.path);
    }
    return null;
  }

  String get flutter =>
      p.join(root, 'bin', 'flutter${Platform.isWindows ? '.bat' : ''}');

  String get dart =>
      p.join(root, 'bin', 'dart${Platform.isWindows ? '.bat' : ''}');

  static bool isValid(FlutterSdk sdk) {
    return File(sdk.flutter).existsSync();
  }
}
