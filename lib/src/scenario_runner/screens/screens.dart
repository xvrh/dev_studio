import 'package:dev_studio_core/scenario_models.dart';
import 'package:flutter/material.dart';
import '../service.dart';
import '../ui/device_frame.dart';
import '../ui/gmail.dart';
import 'email.dart';
import 'json.dart';
import 'pdf.dart';

Widget? widgetForScreen(ScenarioRun run, Screen screen,
    {required ScenarioService service}) {
  var bytes = screen.imageBytes;
  if (bytes != null) {
    return Image.memory(bytes);
  }
  var browser = screen.browser;
  if (browser != null) {
    //TODO(xha): return Browser preview
    return Container(color: Colors.red);
  }

  var email = screen.email;
  if (email != null) {
    return IgnorePointer(
      child: DeviceFrame(
        run: run,
        child: Gmail(
          info: email,
          body: EmailBody(service.htmlScreenshot, run, email),
        ),
      ),
    );
  }

  var pdf = screen.pdf;
  if (pdf != null) {
    return DeviceFrame(
      run: run,
      child: PdfBody(service.htmlScreenshot, run, pdf),
    );
  }

  var json = screen.json;
  if (json != null) {
    return DeviceFrame(
      run: run,
      child: JsonBody(run, json),
    );
  }

  return null;
}
