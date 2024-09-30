import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import '../../client/internal.dart';
import '../ui.dart';
import '../utils/router_outlet.dart';
import 'extra_tools.dart';
import 'flow_graph.dart';
import 'header.dart';
import 'listing.dart';
import 'service.dart';
import 'toolbar.dart';
import 'translations_screenshots.dart';
import 'ui/menu_tree.dart';

class ConnectedScreen extends StatefulWidget {
  final ScenarioService service;
  final ScenarioApi client;

  const ConnectedScreen(
    this.service,
    this.client, {
    super.key,
  });

  @override
  State<ConnectedScreen> createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen> {
  late Future<ProjectInfo> _project;

  @override
  void initState() {
    super.initState();

    _project = widget.client.project.loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProjectInfo>(
      future: _project,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }
          return _MainView(widget.service, widget.client, snapshot.requireData);
        } else {
          return Center(
            child: Text('Loading project...'),
          );
        }
      },
    );
  }
}

class _MainView extends StatelessWidget {
  final ScenarioService service;
  final ScenarioApi client;
  final ProjectInfo projectInfo;

  const _MainView(this.service, this.client, this.projectInfo);

  @override
  Widget build(BuildContext context) {
    return RouterOutlet({
      '': (_) => ProjectView(service, client, projectInfo),
      'tools/translations': (_) =>
          TranslationsScreenshotsTool(projectInfo, client),
    });
  }
}

class ProjectView extends StatefulWidget {
  final ScenarioService service;
  final ScenarioApi client;
  final ProjectInfo projectInfo;

  const ProjectView(this.service, this.client, this.projectInfo, {super.key});

  @override
  State<ProjectView> createState() => ProjectViewState();

  static ProjectViewState of(BuildContext context) =>
      context.findAncestorStateOfType<ProjectViewState>()!;
}

class ProjectViewState extends State<ProjectView> {
  final _headerKey = GlobalKey<HeaderState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          widget.projectInfo,
          key: _headerKey,
          context: widget.service.context,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: ScenarioListingView(widget.client)),
                      ToolsListingView(widget.client),
                    ],
                  )),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.separator,
                ),
                width: 1,
              ),
              Expanded(
                child: ToolBarScope(
                  project: widget.projectInfo,
                  child: RouterOutlet(
                    {
                      'scenario/:scenarioId': (args) {
                        return RunView(
                          widget.service,
                          widget.client,
                          BuiltList(
                              TreePath.fromEncoded(args['scenarioId']).nodes),
                        );
                      },
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  HeaderState get header => _headerKey.currentState!;
}
