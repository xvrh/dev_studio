import 'package:flutter/material.dart';
import '../../../core/html_screenshot.dart' as screenshot;
import '../../../core/scenario_models.dart';
import '../html_screenshot/service.dart';

class PdfBody extends StatefulWidget {
  final HtmlScreenshotService htmlScreenshotService;
  final ScenarioRun run;
  final PdfInfo pdf;

  const PdfBody(this.htmlScreenshotService, this.run, this.pdf, {super.key});

  @override
  State<PdfBody> createState() => _PdfBodyState();
}

class _PdfBodyState extends State<PdfBody> {
  PdfScreenshotResponse? _response;
  Object? _error;

  @override
  void initState() {
    super.initState();

    _loadScreenshot();
  }

  void _loadScreenshot() async {
    var run = widget.run;

    try {
      var response = await widget.htmlScreenshotService.pdfScreenshot(
        screenshot.PdfScreenshotRequest(
          base64Bytes: widget.pdf.bytesBase64,
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
