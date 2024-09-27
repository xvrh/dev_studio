import 'package:dev_studio_client/internal.dart' hide TextInfo;
import 'package:dev_studio_core/html_screenshot.dart' as screenshot;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../detail.dart';
import '../html_screenshot/service.dart';
import '../ui/gmail.dart';
import '../ui/side_bar.dart';
import 'shared/documentation_section.dart';
import 'shared/link.dart';
import 'shared/translation_key.dart';

class EmailDetail extends StatefulWidget {
  final HtmlScreenshotService htmlScreenshotService;
  final ProjectInfo project;
  final ScenarioRun run;
  final Screen screen;
  final EmailInfo email;

  const EmailDetail(
    this.project,
    this.run,
    this.screen,
    this.email, {
    super.key,
    required this.htmlScreenshotService,
  });

  @override
  State<EmailDetail> createState() => _EmailDetailState();
}

class _EmailDetailState extends State<EmailDetail> {
  TextInfo? _overTextInfo;
  LinkInfo? _overLinkInfo;
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
    var screen = widget.screen;
    var documentationKey = screen.documentationKey;

    var error = _error;
    Widget body;
    if (error != null) {
      body = ErrorWidget(error);
    } else {
      body = _EmailBody(
        widget.run,
        widget.screen,
        _response,
        selectedTextInfo: _overTextInfo,
        selectedLink: _overLinkInfo,
      );
    }

    return DetailSkeleton(
      widget.project,
      widget.run,
      screen,
      main: Gmail(
        info: widget.email,
        body: body,
      ),
      sidebar: [
        Expanded(
          flex: 2,
          child: TranslationsSidebar(
            children: [
              for (var text in _response?.texts ?? <TextInfo>[])
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _overTextInfo = text;
                      _overLinkInfo = null;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _overTextInfo = null;
                    });
                  },
                  child: TranslationKeyRow(widget.project, text.toTextInfo()),
                ),
            ],
          ),
        ),
        DetailSkeleton.separator,
        Expanded(
          flex: 1,
          child: SideBar(
            header: Text('Links'),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4),
              children: [
                for (var link in _response?.links ?? <LinkInfo>[])
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _overLinkInfo = link;
                        _overTextInfo = null;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _overLinkInfo = null;
                      });
                    },
                    child: _HtmlLinkRow(link),
                  ),
              ],
            ),
          ),
        ),
        DetailSkeleton.separator,
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

class _EmailBody extends StatelessWidget {
  final ScenarioRun run;
  final Screen screen;
  final HtmlScreenshotResponse? screenshot;
  final TextInfo? selectedTextInfo;
  final LinkInfo? selectedLink;

  const _EmailBody(
    this.run,
    this.screen,
    this.screenshot, {
    this.selectedTextInfo,
    this.selectedLink,
  });

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
              if (selectedTextInfo != null) _TextRect(selectedTextInfo!),
              for (var link in screenshot.links)
                _LinkRect(link, isSelected: link == selectedLink),
            ],
          ),
        ),
      );
    } else {
      return Text(screen.name);
    }
  }
}

class _TextRect extends StatelessWidget {
  final TextInfo text;

  const _TextRect(this.text);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: text.rectangle.y.toDouble(),
      left: text.rectangle.x.toDouble(),
      child: Container(
        width: text.rectangle.width.toDouble(),
        height: text.rectangle.height.toDouble(),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

class _LinkRect extends StatelessWidget {
  final LinkInfo link;
  final bool isSelected;

  const _LinkRect(this.link, {required this.isSelected});

  @override
  Widget build(BuildContext context) {
    var tap = link.rectangle;
    return Positioned(
      top: tap.y.toDouble(),
      left: tap.x.toDouble(),
      child: Container(
        width: tap.width.toDouble(),
        height: tap.height.toDouble(),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.orange : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _HtmlLinkRow extends StatelessWidget {
  final LinkInfo link;

  const _HtmlLinkRow(this.link);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context) => _LinkDialog(link));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              link.text,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              link.href,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkDialog extends StatelessWidget {
  final LinkInfo link;

  const _LinkDialog(this.link);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Link'),
      content: SizedBox(
        width: 350,
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('Text'),
              subtitle: Text(link.text),
            ),
            ListTile(
              title: Text('Url'),
              subtitle: Text(link.href),
              onTap: () {
                Clipboard.setData(ClipboardData(text: link.href));
              },
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            launchUrl(Uri.parse(link.href));
          },
          child: Text('Open Link'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
