import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:dev_studio/src/utils/router_outlet.dart';
import 'package:dev_studio_client/html_screenshot.dart' as html;
import 'package:dev_studio_client/internal.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:puppeteer/puppeteer.dart' as pup;
import 'translations_screenshots_service.dart';

final _logger = Logger('translation_screenshots');

class TranslationsScreenshotsTool extends StatefulWidget {
  final ProjectInfo project;
  final ScenarioApi api;

  const TranslationsScreenshotsTool(this.project, this.api, {super.key});

  @override
  State<TranslationsScreenshotsTool> createState() =>
      _TranslationsScreenshotsToolState();
}

class _TranslationsScreenshotsToolState
    extends State<TranslationsScreenshotsTool> {
  final _searchController = TextEditingController();
  List<Screen>? _screens;
  bool _isRunning = false;
  String? _runningMessage;
  final _runningScenario = <String, String?>{};
  TranslationsScreenshotsService? _service;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screens = _screens;

    Widget mainScreen;
    List<Widget>? menuEntries;
    if (_isRunning) {
      mainScreen = _RunningView(
        message: _runningMessage ?? '',
        scenarios: _runningScenario,
      );
    } else if (screens == null) {
      mainScreen = _StartView(onStart: _start);
    } else {
      var translationKeys =
          screens.expand((s) => s.texts).map((t) => t.translationKey).toSet();
      var searchTerm = _searchController.text.toLowerCase();
      var service = _service!;
      menuEntries = [
        for (var key in translationKeys
            .where((t) => t.toLowerCase().contains(searchTerm))
            .sortedBy((e) => e))
          _TranslationKeyEntry(
            name: key,
            totalScreenshots: screens
                .where((s) => s.texts.any((t) => t.translationKey == key))
                .length,
            filteredCount: service.filterCount(key),
          ),
      ];
      mainScreen = RouterOutlet({
        '': (_) => Container(),
        'keys/:key': (r) {
          var key = r['key'];
          return _ScreenshotsPage(
            service,
            translationKey: key,
            screens: screens
                .where((s) => s.texts.any((t) => t.translationKey == key))
                .toList(),
          );
        },
      });
    }

    return Row(
      children: [
        Container(
          color: Colors.white,
          width: 250,
          child: ListView(
            children: [
              ListTile(
                onTap: () {
                  context.router.go('/');
                },
                title: Text('Back'),
                leading: Icon(Icons.arrow_back),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Search',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.text = '';
                        });
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  onChanged: (_) {
                    setState(() {
                      // Update search
                    });
                  },
                ),
              ),
              ...?menuEntries,
            ],
          ),
        ),
        Expanded(child: mainScreen),
      ],
    );
  }

  void _start() async {
    setState(() {
      _isRunning = true;
      _runningScenario.clear();
      _screens = null;
      _service = null;
    });

    var list = await widget.api.listing.list();
    var screens = <Screen>[];

    setState(() {
      _runningScenario.addAll({
        for (var entry in list.keys) entry.join('/'): null,
      });
    });

    pup.Browser? browser;
    Future<Screen> prepareScreen(Screen screen) async {
      var email = screen.email;
      if (email != null) {
        var nonNullableBrowser = browser ??=
            await pup.puppeteer.launch(executablePath: pup.BrowserPath.chrome);
        var screenshot = await html.htmlScreenshot(
            html.HtmlScreenshotRequest(
                html: _wrapEmailBody(email),
                device: html.DeviceInfo(
                  width: DeviceInfo.iPhoneX.width.toInt(),
                  height: DeviceInfo.iPhoneX.height.toInt(),
                  pixelRatio: 0.5,
                )),
            browser: nonNullableBrowser);
        screen = screen.rebuild(
          (s) => s
            ..imageBytes = screenshot.image
            ..texts.addAll(
              screenshot.texts.map((t) => t.toTextInfo()),
            ),
        );
      }
      return screen;
    }

    var count = list.entries.length;
    var i = 0;
    for (var entry in list.entries) {
      setState(() {
        _runningMessage = '${i + 1}/$count: ${entry.key.join('/')}';
      });

      var runReference = widget.api.run.start(RunArgs(entry.key,
          device: DeviceInfo.iPhoneX,
          accessibility: AccessibilityConfig.defaultValue,
          language: 'en',
          imageRatio: 0.5));
      await for (var update in runReference.onUpdated) {
        if (update.isCompleted) {
          for (var screen in update.screens.values) {
            screens.add(await prepareScreen(screen));
          }
          setState(() {
            _runningScenario[entry.key.join('/')] = update.result!.error ?? '';
          });
          break;
        }
      }

      ++i;
    }
    if (browser != null) {
      await browser!.close();
    }

    try {
      File codeFile(String name) => File(p.join(widget.project.currentDirectory,
              widget.project.rootPath!, 'tool/$name.dart'))
          .absolute;
      var service = await TranslationsScreenshotsService.load(
          filterFile: codeFile('translations_screenshots'),
          definitionFile: codeFile('translations_screenshots.gen'),
          screens: screens);

      setState(() {
        _service = service;
        _screens = screens;
        _isRunning = false;
      });
    } catch (e, s) {
      _logger.severe('Error loading translation/screenshot tool $e $s');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _StartView extends StatelessWidget {
  final VoidCallback onStart;

  const _StartView({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: onStart,
        child: Text('Run all tests'),
      ),
    );
  }
}

class _RunningView extends StatelessWidget {
  final String message;
  final Map<String, String?> scenarios;

  const _RunningView({required this.message, required this.scenarios});

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      children: [
        const SizedBox(height: 10),
        Center(child: CircularProgressIndicator()),
        const SizedBox(height: 10),
        Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        for (var scenario in scenarios.entries)
          Row(
            children: [
              Text(scenario.key),
              if (scenario.value != null && scenario.value!.isEmpty)
                Icon(Icons.check)
              else if (scenario.value != null && scenario.value!.isEmpty)
                Icon(Icons.error_outline)
              else
                Icon(
                  Icons.add,
                  color: Colors.transparent,
                ),
            ],
          ),
      ],
    );
  }
}

class _TranslationKeyEntry extends StatelessWidget {
  final String name;
  final int totalScreenshots;
  final int? filteredCount;

  const _TranslationKeyEntry({
    required this.name,
    required this.totalScreenshots,
    this.filteredCount,
  });

  @override
  Widget build(BuildContext context) {
    var isOk = filteredCount != null || totalScreenshots == 1;
    return InkWell(
      onTap: () {
        context.router.go('keys/$name');
      },
      child: Container(
        color: context.router.isSelected('keys/$name')
            ? Colors.blueAccent.withOpacity(0.5)
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (isOk)
              Icon(Icons.check, color: Colors.green, size: 15)
            else
              Icon(Icons.pending_actions, color: Colors.red, size: 15),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                name,
                style: const TextStyle(fontSize: 12),
                softWrap: true,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${filteredCount != null ? '$filteredCount / ' : ''}$totalScreenshots',
              softWrap: false,
              style: TextStyle(
                color: isOk ? Colors.black26 : Colors.red,
                fontWeight: isOk ? FontWeight.normal : FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenshotsPage extends StatelessWidget {
  final TranslationsScreenshotsService service;
  final String translationKey;
  final List<Screen> screens;

  const _ScreenshotsPage(this.service,
      {required this.screens, required this.translationKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          translationKey,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: SingleChildScrollView(
            primary: false,
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                for (var screen in screens)
                  _ScreenshotTile(service, translationKey, screen),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScreenshotTile extends StatefulWidget {
  final TranslationsScreenshotsService service;
  final String translationKey;
  final Screen screen;

  const _ScreenshotTile(this.service, this.translationKey, this.screen);

  @override
  State<_ScreenshotTile> createState() => _ScreenshotTileState();
}

class _ScreenshotTileState extends State<_ScreenshotTile> {
  @override
  Widget build(BuildContext context) {
    var bytes = widget.screen.imageBytes;
    Widget image;
    if (bytes != null) {
      image = Image.memory(bytes);
    } else {
      image = Container(color: Colors.red);
    }

    var text = widget.screen.texts
        .firstWhere((t) => t.translationKey == widget.translationKey);

    var isChecked =
        widget.service.isFiltered(widget.translationKey, widget.screen);
    image = Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isChecked ? Colors.greenAccent : Colors.transparent,
          width: 4,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: image,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Text(
                '${widget.screen.scenarioName.join('/')} - ${widget.screen.pathTrail.join('-')} - ${widget.screen.name}'),
          ),
        ],
      ),
    );

    return Stack(
      children: [
        image,
        Positioned(
          top: text.globalRectangle.top,
          left: text.globalRectangle.left,
          child: Container(
            width: text.globalRectangle.width + 4,
            height: text.globalRectangle.height + 4,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.redAccent, width: 2),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Checkbox(
            activeColor: Colors.greenAccent,
            value: isChecked,
            onChanged: (v) {
              setState(() {
                widget.service
                    .toggleFilter(widget.translationKey, widget.screen, v!);
              });
            },
          ),
        ),
      ],
    );
  }
}

String _wrapEmailBody(EmailInfo email) {
  return '''
<div style="text-align: left">
  <p style="font-size: 10px; color: lightgrey">EMAIL</p>
  <h2 ${html.translationKeyHtmlAttribute}="${HtmlEscape().convert(email.subjectTranslationKey)}">
    ${HtmlEscape().convert(email.subject)}
  </h2>
</div>
<hr>
${email.body}  
''';
}
