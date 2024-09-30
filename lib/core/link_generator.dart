Uri Function(String) poEditorTranslationLink({required int projectId}) {
  return (key) {
    return Uri.parse('https://poeditor.com/projects/view_terms')
        .replace(queryParameters: {
      'id': '$projectId',
      'search': key,
    });
  };
}

Uri Function(String) lokaliseTranslationLink({required String projectId}) {
  return (key) {
    return Uri.parse(
        'https://app.lokalise.com/project/$projectId/?view=multi&search=$key');
  };
}

Uri Function(String) firebaseEventLink(
    {required String projectId, required String androidAppId}) {
  return (key) {
    return Uri.parse(
            'https://console.firebase.google.com/u/0/project/$projectId/analytics/app/android:$androidAppId/events/')
        .replace(queryParameters: {'q': key});
  };
}

typedef ScenarioUrlFactory = Uri Function(Iterable<String>, String?);
ScenarioUrlFactory scenarioLink(String baseUrl) {
  return (scenarioName, screenId) {
    var url =
        '$baseUrl#/scenario/${Uri.encodeComponent(scenarioName.join('/'))}';
    if (screenId != null) {
      url += '/detail/$screenId';
    }
    return Uri.parse(url);
  };
}

Uri Function(String) confluencePageLink(
    {required String site, required String space}) {
  return (pageId) {
    return Uri.https('$site.atlassian.net', 'wiki/spaces/$space/pages/$pageId');
  };
}
