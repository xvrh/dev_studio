import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../client/internal.dart';
import '../../../../core/link_generator.dart';

class AnalyticEventDialog extends StatelessWidget {
  final ProjectInfo project;
  final AnalyticEvent event;

  const AnalyticEventDialog(this.project, this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    var firebaseInfo = project.firebase;
    return AlertDialog(
      title: Row(
        children: [
          Image.asset(
            'assets/google_analytics.png',
            package: 'dev_studio',
            height: 30,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text('Analytic event')),
        ],
      ),
      content: SizedBox(
        width: 350,
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('Event'),
              subtitle: Text(event.event),
            ),
            ListTile(
              title: Text('Parameters'),
              subtitle: Text(event.args.toString()),
            ),
          ],
        ),
      ),
      actions: [
        if (firebaseInfo != null)
          OutlinedButton(
            onPressed: () {
              var link = firebaseEventLink(
                projectId: firebaseInfo.projectId,
                androidAppId: firebaseInfo.androidAppId,
              )(event.event);
              launchUrl(link);
            },
            child: Text('Open Firebase'),
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
