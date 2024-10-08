import 'package:flutter/material.dart';
import '../../client/internal.dart';
import '../utils/router_outlet.dart';
import 'ui/side_bar.dart';

class ToolsListingView extends StatelessWidget {
  final ScenarioApi api;

  const ToolsListingView(this.api, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SidebarHeader(title: Text('Tools')),
        InkWell(
          onTap: () {
            context.router.go('/tools/translations');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: Text('Translations screenshots'),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
