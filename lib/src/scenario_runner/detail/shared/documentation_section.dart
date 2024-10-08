import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../client/internal.dart';
import '../../ui/side_bar.dart';

class DocumentationSection extends StatelessWidget {
  final ProjectInfo project;
  final ScenarioRun run;
  final String documentationKey;

  const DocumentationSection(
    this.project,
    this.run, {
    super.key,
    required this.documentationKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SidebarHeader(title: Text('Documentation')),
        ListTile(
          dense: true,
          leading: SizedBox(
            width: 20,
            child: Image.asset(
              'assets/confluence.png',
              package: 'dev_studio',
            ),
          ),
          minLeadingWidth: 20,
          title: Text(documentationKey),
          onTap: () {
            var confluenceInfo = project.confluence;
            if (confluenceInfo != null) {
              //https://riiotlabs.atlassian.net/wiki/search?text=FP%20doc%20-%20Onboarding%20%3E%20Splash

              var confluenceUrl = Uri.https(
                  '${confluenceInfo.site}.atlassian.net', 'wiki/search', {
                'text': '${confluenceInfo.docPrefix} ${[
                  ...run.scenario.name,
                  documentationKey
                ].join(' > ')}',
              });
              launchUrl(confluenceUrl);
            }
          },
        )
      ],
    );
  }
}
