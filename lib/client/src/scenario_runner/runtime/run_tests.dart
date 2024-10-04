import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart'
    show AutomatedTestWidgetsFlutterBinding, WidgetController;
import 'package:path/path.dart' as p;
import 'package:puppeteer/puppeteer.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import '../../../../core/utils_string.dart';
import '../../fonts.dart';
import '../html_screenshot/puppeteer.dart' as screenshot;
import '../protocol/models.dart';
import 'asset_bundle_io.dart';
import 'binding.dart';
import 'scenario.dart';
import 'scenario_ref.dart';
import 'setup.dart';

class TestRunner {
  final Map<String, dynamic> scenarios;
  final List<String> languages;
  final List<DeviceInfo> devices;
  final List<DeviceInfo>? desktopDevices;
  final String? projectRoot;

  TestRunner(
    this.scenarios, {
    required this.languages,
    required this.devices,
    this.desktopDevices,
    this.projectRoot,
  });

  late AutomatedTestWidgetsFlutterBinding _binding;
  late IOAssetBundle _bundle;
  void _setup() {
    WidgetController.hitTestWarningShouldBeFatal = true;
    WidgetsApp.debugAllowBannerOverride = false;
    RenderErrorBox.textStyle = ui.TextStyle(fontFamily: 'Roboto');

    _binding = ScenarioBinding(onReloaded: () {});
    String? projectPackageName;
    var projectRoot = this.projectRoot;
    if (projectRoot != null) {
      projectPackageName = _packageNameAt(projectRoot);
    }
    _bundle = IOAssetBundle(
      'build/unit_test_assets',
      bundleParams: BundleParameters(
        rootProjectPath: projectRoot,
        projectPackageName: projectPackageName,
      ),
    );

    setUpAll(() async {
      await loadAppFonts(_bundle);
      await loadFonts({
        ...await commonFonts,
      });
    });
  }

  List<DeviceInfo> devicesForScenario(Scenario scenario) {
    return (scenario.isDesktop ? desktopDevices : null) ?? devices;
  }

  void runTests() {
    var runContext = _EmptyRunContext();

    _setup();

    var project = ProjectInfo('',
        rootPath: projectRoot,
        currentDirectory: Directory.current.path,
        supportedLanguages: languages);
    for (var language in languages) {
      for (var ref in ScenarioRef.flatten(scenarios)) {
        for (var device in devicesForScenario(ref.scenario)) {
          var args = RunArgs(
            ref.name,
            device: device,
            accessibility: AccessibilityConfig(),
            language: language,
            imageRatio: 0,
          );
          test('[${ref.name.join('/')}][$language][${device.name}]', () async {
            var error = await ref.scenario.execute(
              runContext,
              _binding,
              _bundle,
              project,
              args,
            );
            if (error != null) {
              throw Exception(error);
            }
          });
        }
      }
    }
  }

  void runForDocumentation({
    required Future<void> Function(List<DocumentationScreen>) onCompleted,
    required Directory imageOutputDirectory,
    required double Function(DeviceInfo) imageRatio,
    bool? onlyWithDocumentationKey,
  }) {
    onlyWithDocumentationKey ??= true;
    var runContext = _DocumentationRunContext(imageOutputDirectory);

    _setup();

    test('Run all', () async {
      var project = ProjectInfo('',
          rootPath: projectRoot,
          currentDirectory: Directory.current.path,
          supportedLanguages: languages);
      for (var language in languages) {
        for (var ref in ScenarioRef.flatten(scenarios)) {
          for (var device in devicesForScenario(ref.scenario)) {
            var args = RunArgs(
              ref.name,
              device: device,
              accessibility: AccessibilityConfig(),
              language: language,
              imageRatio: imageRatio(device),
              onlyWithDocumentationKey: onlyWithDocumentationKey,
            );

            var error = await ref.scenario.execute(
              runContext,
              _binding,
              _bundle,
              project,
              args,
            );
            if (error != null) {
              throw Exception(error);
            }
          }
        }
      }

      await onCompleted(runContext.screens.values.toList());
      await runContext.dispose();
    }, timeout: Timeout(Duration(minutes: 100)));
  }
}

class _EmptyRunContext implements RunContext {
  @override
  Future<void> addScreen(RunArgs args, NewScreen newScreen) async {
    // Discard the screen
  }
}

class _DocumentationRunContext implements RunContext {
  final Directory tempDirectory;
  final screens = <String, DocumentationScreen>{};
  Browser? _browser;

  _DocumentationRunContext(this.tempDirectory);

  @override
  Future<void> addScreen(RunArgs args, NewScreen newScreen) async {
    File? file;
    var imageBase64 = newScreen.imageBase64;
    var email = newScreen.screen.email;
    var screen = newScreen.screen;
    var fileName =
        '${args.scenarioName.join('_')}${newScreen.screen.pathTrail.join('_')}_${newScreen.screen.name}'
            .words
            .map((s) => s.toLowerCase())
            .toSnakeCase();
    var filePath = p.join(tempDirectory.path, '$fileName.png');
    if (imageBase64 != null) {
      var image = base64Decode(imageBase64);
      file = File(filePath)..writeAsBytesSync(image);
    } else if (email != null) {
      var browser = _browser;
      browser ??=
          _browser = await puppeteer.launch(executablePath: BrowserPath.chrome);
      var screenshotResponse = await screenshot.htmlScreenshot(
        screenshot.HtmlScreenshotRequest(
          html: _wrapEmailBody(email),
          device: screenshot.DeviceInfo(
            width: args.device.width.round(),
            height: args.device.height.round(),
            pixelRatio: args.imageRatio,
          ),
        ),
        browser: browser,
      );
      file = File(filePath)..writeAsBytesSync(screenshotResponse.image);
      screen = screen.rebuild(
        (s) => s.texts.addAll(
          screenshotResponse.texts.map((t) => t.toTextInfo()),
        ),
      );
    }

    String screenId(String id) => '${args.scenarioName.join('_')}-$id';

    var parentId = newScreen.parent;
    if (parentId != null) {
      var parent = screens[screenId(parentId)]!;
      screens[screenId(parentId)] = parent.rebuild((parentBuilder) {
        parentBuilder.screen.next.add(
          ScreenLink(screen.id).rebuild((r) {
            var analyticEvent = newScreen.analyticEvent;
            if (analyticEvent != null) {
              r.analytic.replace(analyticEvent);
            }
          }),
        );
      });
    }

    screens[screenId(screen.id)] = DocumentationScreen(file, screen, args);
  }

  Future<void> dispose() async {
    await _browser?.close();
  }
}

String _packageNameAt(String location) {
  var pubspecContent =
      File(p.join(location, 'pubspec.yaml')).readAsStringSync();
  var pubspec = loadYaml(pubspecContent) as YamlMap;
  return pubspec['name']! as String;
}

String _wrapEmailBody(EmailInfo email) {
  return '''
<div style="text-align: left">
  <p style="font-size: 10px; color: lightgrey">EMAIL</p>
  <h2 ${screenshot.translationKeyHtmlAttribute}="${HtmlEscape().convert(email.subjectTranslationKey)}">
    ${HtmlEscape().convert(email.subject)}
  </h2>
</div>
<hr>
${email.body}  
''';
}
