import 'dart:io';
import 'package:dev_studio_core/documentation.dart'
    show TranslationScreenshotUtilities;
import 'package:dev_studio_core/scenario_models.dart' show Screen;
import 'package:dev_studio_core/utils_string.dart';

class TranslationsScreenshotsService {
  final File filterFile;
  final File definitionFile;

  // Key=translationKey already encoded in lowerCamelCase
  final Map<String, List<Screen>> _filters;

  TranslationsScreenshotsService._({
    required this.filterFile,
    required this.definitionFile,
    required Map<String, List<Screen>> filters,
  }) : _filters = filters;

  static Future<TranslationsScreenshotsService> load(
      {required File filterFile,
      required File definitionFile,
      required List<Screen> screens}) async {
    var filters = TranslationScreenshotUtilities.parseFiltersCode(
        filterFile.readAsStringSync());

    var initialFilters = <String, List<Screen>>{};
    for (var filter in filters.entries) {
      var filteredScreens = screens
          .where((s) => filter.value.any((f) => f == _screenName(s)))
          .toList();
      if (filteredScreens.isNotEmpty) {
        initialFilters[filter.key] = filteredScreens;
      }
    }

    definitionFile.writeAsStringSync(
        TranslationScreenshotUtilities.generateListCode(screens));

    return TranslationsScreenshotsService._(
        filterFile: filterFile,
        definitionFile: definitionFile,
        filters: initialFilters);
  }

  int? filterCount(String translationKey) {
    translationKey = _normalizeKey(translationKey);

    return _filters[translationKey]?.length;
  }

  bool isFiltered(String translationKey, Screen screen) {
    translationKey = _normalizeKey(translationKey);

    var filter = _filters[translationKey];
    if (filter != null) {
      return filter.contains(screen);
    }
    return false;
  }

  void toggleFilter(String translationKey, Screen screen, bool enable) {
    translationKey = _normalizeKey(translationKey);

    var filter = _filters[translationKey];
    if (filter != null) {
      if (enable) {
        filter.add(screen);
      } else {
        filter.remove(screen);
      }
    } else if (enable) {
      _filters[translationKey] = [screen];
    }

    _saveFilters();
  }

  void _saveFilters() {
    var filters = _filters
        .map((key, value) => MapEntry(key, value.map(_screenName).toList()));
    filterFile.writeAsStringSync(
        TranslationScreenshotUtilities.generateFiltersCode(filters));
  }

  static String _normalizeKey(String key) {
    return key.words.toLowerCamel();
  }

  static String _screenName(Screen screen) {
    return '${screen.scenarioName.join('_')}_${screen.pathTrail.join('_')}_${screen.name}'
        .words
        .toLowerCamel();
  }
}
