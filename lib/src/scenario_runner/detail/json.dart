import 'dart:convert';
import 'package:dev_studio_client/internal.dart' hide TextInfo;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import '../detail.dart';
import '../ui/side_bar.dart';
import 'shared/link.dart';

class JsonDetail extends StatelessWidget {
  final ProjectInfo project;
  final ScenarioRun run;
  final Screen screen;
  final JsonInfo json;

  const JsonDetail(
    this.project,
    this.run,
    this.screen,
    this.json, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var body = SelectableText(json.data);

    return DetailSkeleton(
      project,
      run,
      screen,
      main: body,
      sidebar: [
        Expanded(
          child: SideBar(
            header: Text('JSON'),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: OutlinedButton(
                    onPressed: () async {
                      var location = await getSaveLocation(
                        suggestedName: json.fileName,
                      );
                      if (location != null) {
                        var data = Uint8List.fromList(utf8.encode(json.data));
                        var file = XFile.fromData(data,
                            name: p.basename(location.path),
                            mimeType: 'application/json');
                        await file.saveTo(location.path);
                      }
                    },
                    child: Text('Download file'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: json.data));
                    },
                    child: Text('Copy to clipboard'),
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
                    project,
                    run.screens[next.to]!,
                    next,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
