import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import '../scenario/model/screen.dart';
import '../utils/source_code.dart';
import '../utils/string.dart';

class TranslationScreenshotUtilities {
  static Map<String, List<String>> parseFiltersCode(String dartCode) {
    var parsed = parseString(content: dartCode);
    var variableDeclaration = parsed.unit.declarations
        .whereType<TopLevelVariableDeclaration>()
        .firstWhere((e) =>
            e.variables.variables.any((v) => v.name.value() == 'screenshots'));
    var initializer = variableDeclaration.variables.variables.first.initializer!
        as MethodInvocation;

    var result = <String, List<String>>{};
    for (var argument
        in initializer.argumentList.arguments.cast<NamedExpression>()) {
      var valueCode = argument.expression as SetOrMapLiteral;

      var values = <String>[];
      for (var setEntry in valueCode.elements.cast<PrefixedIdentifier>()) {
        values.add(setEntry.identifier.name);
      }

      result[argument.name.label.name] = values;
    }
    return result;
  }

  static String generateFiltersCode(Map<String, List<String>> filters) {
    var code = StringBuffer();

    code.writeln("import 'translations_screenshots.gen.dart';");
    code.writeln('final screenshots = screenshotsForTranslations(');
    for (var entry in filters.entries.sortedBy((e) => e.key)) {
      if (entry.value.isEmpty) continue;
      code.writeln('${entry.key}: {');

      var screenPrefix = entry.key.toCapitalized();
      for (var value in entry.value) {
        code.writeln('$screenPrefix.${value.words.toLowerCamel()},');
      }
      code.writeln('},');
    }
    code.writeln(');');
    return DartFormatter().format('$code');
  }

  static String generateListCode(List<Screen> screens) {
    Iterable<Screen> screensForKey(String translationKey) {
      return screens
          .where((e) => e.texts.any((t) => t.translationKey == translationKey));
    }

    String screenNameFor(Screen screen) {
      return '${screen.scenarioName.join('_')}_${screen.pathTrail.join('_')}_${screen.name}';
    }

    var translationKeys = screens
        .expand((s) => s.texts)
        .map((t) => t.translationKey)
        .toSet()
        .sortedBy((e) => e);

    var code = StringBuffer();
    code.writeln(
        '// GENERATED CODE: flutter test tool/generate_translation_screenshot_code.dart');
    code.writeln();
    code.writeln(
        "import 'package:dev_studio_core/documentation.dart' show ScreenIdentifier;");

    code.writeln(
        'Map<String, Set<ScreenIdentifier>?> screenshotsForTranslations({');
    for (var translationKey in translationKeys) {
      var screenshots = screensForKey(translationKey);
      assert(translationKey.isNotEmpty);
      assert(translationKey.words.isNotEmpty);
      assert(screenshots.isNotEmpty);

      var isOptional = screenshots.length == 1;

      code.writeln(
          '${isOptional ? '' : 'required'} Set<${translationKey.words.toUpperCamel()}>${isOptional ? '?' : ''} ${translationKey.words.toLowerCamel()},');
    }
    code.writeln('}) {');
    code.writeln('return {');
    for (var translationKey in translationKeys) {
      var screenshots = screensForKey(translationKey);

      if (screenshots.isNotEmpty) {
        code.writeln(
            '${escapeDartString(translationKey)}: ${translationKey.words.toLowerCamel()},');
      }
    }
    code.writeln('}; }');

    code.writeln('''
mixin TranslationKey implements ScreenIdentifier {
  ScreenIdentifier get screenId;
  
  @override
  List<String> get scenario => screenId.scenario;
  
  @override
  List<String> get path => screenId.path;
  
  @override
  String get screen => screenId.screen;
}
''');

    for (var screen in screens) {
      if (screen.texts.isNotEmpty) {
        var screenName = screenNameFor(screen);

        code.writeln(
            'const _${screenName.words.toLowerCamel()} = ScreenIdentifier('
            '[${screen.scenarioName.map(escapeDartString).join(', ')}],'
            '[${screen.pathTrail.map(escapeDartString).join(', ')}],'
            '${escapeDartString(screen.name)});');
      }
    }

    for (var translationKey in translationKeys) {
      var screenshots = screensForKey(translationKey);

      if (screenshots.isNotEmpty) {
        code.writeln(
            'enum ${translationKey.words.toUpperCamel()} with TranslationKey {');
        for (var screenshot in screenshots) {
          var screenName = screenNameFor(screenshot);

          code.writeln(
              '${screenName.words.toLowerCamel()}(_${screenName.words.toLowerCamel()}),');
        }

        code.writeln('''
;

@override
final ScreenIdentifier screenId;

const ${translationKey.words.toUpperCamel()}(this.screenId);      
''');
        code.writeln('}');
      }
    }

    return DartFormatter().format('$code');
  }
}
