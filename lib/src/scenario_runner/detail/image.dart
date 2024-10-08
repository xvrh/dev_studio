import 'package:flutter/material.dart';
import '../../../client/internal.dart';
import '../detail.dart';
import '../ui/side_bar.dart';
import 'shared/documentation_section.dart';
import 'shared/link.dart';
import 'shared/translation_key.dart';

class ImageDetail extends StatefulWidget {
  final ProjectInfo project;
  final ScenarioRun run;
  final Screen screen;

  const ImageDetail(this.project, this.run, this.screen, {super.key});

  @override
  State<ImageDetail> createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  TextInfo? _overTextInfo;
  ScreenLink? _overLink;

  @override
  Widget build(BuildContext context) {
    var screen = widget.screen;
    var documentationKey = screen.documentationKey;

    return DetailSkeleton(
      widget.project,
      widget.run,
      screen,
      main: _Screenshot(
        widget.run,
        widget.screen,
        selectedTextInfo: _overTextInfo,
        selectedLink: _overLink,
      ),
      sidebar: [
        Expanded(
          flex: 2,
          child: TranslationsSidebar(
            children: [
              for (var text in screen.texts)
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _overTextInfo = text;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _overTextInfo = null;
                    });
                  },
                  child: TranslationKeyRow(widget.project, text),
                ),
            ],
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
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _overLink = next;
                        _overTextInfo = null;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _overLink = null;
                      });
                    },
                    child: LinkRow(
                      widget.project,
                      widget.run.screens[next.to]!,
                      next,
                    ),
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

class _Screenshot extends StatelessWidget {
  final ScenarioRun run;
  final Screen screen;
  final TextInfo? selectedTextInfo;
  final ScreenLink? selectedLink;

  const _Screenshot(
    this.run,
    this.screen, {
    this.selectedTextInfo,
    this.selectedLink,
  });

  @override
  Widget build(BuildContext context) {
    var bytes = screen.imageBytes;
    Widget image;
    if (bytes != null) {
      image = Image.memory(bytes);
    } else {
      image = Center(child: Text(screen.name));
    }

    return Stack(
      children: [
        Positioned.fill(child: image),
        if (selectedTextInfo != null) _TextRect(selectedTextInfo!),
        for (var next in screen.next)
          if (next.tapRect != null)
            _LinkRect(next, isSelected: next == selectedLink),
      ],
    );
  }
}

class _TextRect extends StatelessWidget {
  final TextInfo text;

  const _TextRect(this.text);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: text.globalRectangle.top,
      left: text.globalRectangle.left,
      child: Container(
        width: text.globalRectangle.width,
        height: text.globalRectangle.height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

class _LinkRect extends StatelessWidget {
  final ScreenLink link;
  final bool isSelected;

  const _LinkRect(this.link, {required this.isSelected});

  @override
  Widget build(BuildContext context) {
    var tap = link.tapRect!;
    return Positioned(
      top: tap.top,
      left: tap.left,
      child: Container(
        width: tap.width,
        height: tap.height,
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
