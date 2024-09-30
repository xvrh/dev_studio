import 'package:rxdart/rxdart.dart';
import '../../client/internal.dart';
import '../../core/web_manifest.dart';
import 'html_screenshot/service.dart';

class ScenarioService {
  final ValueStream<List<ScenarioApi>> clients;
  final ScenarioContext context;
  final HtmlScreenshotService htmlScreenshot;

  ScenarioService(
    this.clients,
    this.context, {
    required this.htmlScreenshot,
  });
}

class ScenarioContext {
  final WebManifest? manifest;
  final BuildInfo? build;

  ScenarioContext({
    this.manifest,
    this.build,
  });
}
