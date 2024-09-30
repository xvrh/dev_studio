import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'client/internal.dart';
import 'client/internal_web.dart';
import 'core/web_manifest.dart';
import 'src/scenario_runner/app.dart';
import 'src/scenario_runner/html_screenshot/service.dart';
import 'src/scenario_runner/service.dart';
import 'src/scenario_runner/standalone.dart';

void main() async {
  var buildInfoRaw = document.body?.attributes['build-info'];
  BuildInfo? buildInfo;
  WebManifest? manifest;
  if (buildInfoRaw != null && buildInfoRaw.isNotEmpty) {
    buildInfo =
        BuildInfo.fromJson(jsonDecode(buildInfoRaw) as Map<String, dynamic>);
    var manifestPath = buildInfo.manifestPath;
    if (manifestPath != null) {
      var manifestContent = await read(Uri.parse(manifestPath));
      manifest = WebManifest.fromJson(
          jsonDecode(manifestContent) as Map<String, dynamic>);
    }
  }

  late BehaviorSubject<List<ScenarioApi>> subject;

  var iframe = IFrameElement()
    //ignore: unsafe_html
    ..src = 'client/index.html'
    ..height = '0'
    ..width = '0';

  late StreamSubscription onMessageSubscription;
  onMessageSubscription = window.onMessage.listen((e) {
    if (e.data == onConnectedMessage) {
      onMessageSubscription.cancel();
      var channel = createWebChannel(iframe.contentWindow!);
      var client = ScenarioApi(channel, onClose: () {
        subject.close();
      });
      subject.add([client]);
    }
  });

  document.body!.children.add(iframe);

  subject = BehaviorSubject.seeded([]);

  var service = ScenarioService(
    subject.stream,
    ScenarioContext(
      build: buildInfo,
      manifest: manifest,
    ),
    htmlScreenshot: CachedHtmlScreenshotService(
      RemoteHtmlScreenshotService(
        Uri.https('lt100o5bki.execute-api.eu-central-1.amazonaws.com',
            'prod/html-screenshot/capture'),
      ),
      maxSize: 20,
    ),
  );
  runApp(StandaloneScenarioApp(ScenarioApp(service)));
}
