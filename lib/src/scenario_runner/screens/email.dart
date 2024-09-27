import 'package:dev_studio_core/html_screenshot.dart' as screenshot;
import 'package:dev_studio_core/scenario_models.dart';
import 'package:flutter/material.dart';
import '../html_screenshot/service.dart';

class EmailBody extends StatefulWidget {
  final HtmlScreenshotService htmlScreenshotService;
  final ScenarioRun run;
  final EmailInfo email;

  const EmailBody(this.htmlScreenshotService, this.run, this.email,
      {super.key});

  @override
  State<EmailBody> createState() => _EmailBodyState();
}

class _EmailBodyState extends State<EmailBody> {
  HtmlScreenshotResponse? _response;
  Object? _error;

  @override
  void initState() {
    super.initState();

    _loadScreenshot();
  }

  void _loadScreenshot() async {
    var run = widget.run;

    try {
      var response = await widget.htmlScreenshotService.htmlScreenshot(
        screenshot.HtmlScreenshotRequest(
          html: widget.email.body,
          device: screenshot.DeviceInfo(
            width: run.args.device.width.round(),
            height: run.args.device.height.round(),
            pixelRatio: run.args.imageRatio,
          ),
        ),
      );
      setState(() {
        _response = response;
      });
    } catch (e) {
      setState(() {
        _error = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var error = _error;
    var response = _response;
    if (error != null) {
      return ErrorWidget(error);
    } else if (response == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Image.memory(response.image);
    }
  }
}
