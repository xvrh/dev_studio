import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'src/scenario_runner/app.dart';
import 'src/scenario_runner/html_screenshot/service.dart';
import 'src/scenario_runner/html_screenshot/service_local.dart';
import 'src/scenario_runner/service.dart';
import 'src/scenario_runner/standalone.dart';

void main() {
  Logger.root
    ..level = Level.INFO
    ..onRecord.listen(print);
  runApp(StandaloneScenarioApp(ScenarioAppWithServer(
    serviceFactory: (clients) => ScenarioService(
      clients,
      ScenarioContext(),
      htmlScreenshot: CachedHtmlScreenshotService(
        LocalHtmlScreenshotService(),
        maxSize: 100,
      ),
    ),
  )));
}
