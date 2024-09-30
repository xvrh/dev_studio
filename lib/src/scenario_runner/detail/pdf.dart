import 'dart:convert';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../../../client/internal.dart' hide TextInfo;
import '../../../core/html_screenshot.dart' as screenshot;
import '../detail.dart';
import '../html_screenshot/service.dart';
import '../ui/side_bar.dart';
import 'shared/documentation_section.dart';
import 'shared/link.dart';

class PdfDetail extends StatefulWidget {
  final HtmlScreenshotService htmlScreenshotService;
  final ProjectInfo project;
  final ScenarioRun run;
  final Screen screen;
  final PdfInfo pdf;

  const PdfDetail(
    this.project,
    this.run,
    this.screen,
    this.pdf, {
    super.key,
    required this.htmlScreenshotService,
  });

  @override
  State<PdfDetail> createState() => _PdfDetailState();
}

class _PdfDetailState extends State<PdfDetail> {
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
    var screen = widget.screen;
    var documentationKey = screen.documentationKey;

    var error = _error;
    Widget body;
    if (error != null) {
      body = ErrorWidget(error);
    } else {
      body = _PdfBody(
        widget.run,
        widget.screen,
        _response,
      );
    }

    return DetailSkeleton(
      widget.project,
      widget.run,
      screen,
      main: body,
      sidebar: [
        Expanded(
          child: SideBar(
            header: Text('PDF'),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4),
              children: [
                ListTile(
                    title: Text('File'), subtitle: Text(widget.pdf.fileName)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: OutlinedButton(
                    onPressed: () async {
                      var location = await getSaveLocation(
                        suggestedName: widget.pdf.fileName,
                      );
                      if (location != null) {
                        var data = Uint8List.fromList(
                            base64Decode(widget.pdf.bytesBase64));
                        var file = XFile.fromData(data,
                            name: p.basename(location.path),
                            mimeType: 'application/pdf');
                        await file.saveTo(location.path);
                      }
                    },
                    child: Text('Download'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SideBar(
            header: Text('Next'),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4),
              children: [
                for (var next in screen.next)
                  LinkRow(
                    widget.project,
                    widget.run.screens[next.to]!,
                    next,
                  ),
              ],
            ),
          ),
        ),
        if (documentationKey != null) ...[
          DetailSkeleton.separator,
          DocumentationSection(widget.project, widget.run,
              documentationKey: documentationKey),
        ]
      ],
    );
  }
}

class _PdfBody extends StatelessWidget {
  final ScenarioRun run;
  final Screen screen;
  final PdfScreenshotResponse? screenshot;

  const _PdfBody(this.run, this.screen, this.screenshot);

  @override
  Widget build(BuildContext context) {
    var screenshot = this.screenshot;
    if (screenshot != null) {
      return FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: screenshot.imageWidth.toDouble(),
          height: screenshot.imageHeight.toDouble(),
          child: Stack(
            children: [
              Image.memory(
                screenshot.image,
                fit: BoxFit.none,
              ),
            ],
          ),
        ),
      );
    } else {
      return Text(screen.name);
    }
  }
}
