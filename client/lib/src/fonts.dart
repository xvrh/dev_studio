import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:package_config/package_config.dart';

Future<String> commonFontsPath = (() async {
  var packageConfig = (await findPackageConfig(Directory.current))!;
  var testUtilsPackage = packageConfig['dev_studio_client']!;
  return testUtilsPackage.packageUriRoot.resolve('fonts').toFilePath();
})();

Future<Map<String, String>> get commonFonts async {
  final path = await commonFontsPath;
  return {
    'Roboto': '$path/Roboto',
    'CupertinoSystemDisplay': '$path/SF-Pro-Display',
    'CupertinoSystemText': '$path/SF-Pro-Text',
  };
}

Future<String> get ahemFont async {
  final path = await commonFontsPath;
  return '$path/Ahem';
}

Future<void> loadFonts(Map<String, String> fonts) async {
  for (var font in fonts.entries) {
    var fontLoader = FontLoader(font.key);

    var fontFiles = Directory(font.value).listSync().whereType<File>().toList();
    fontFiles.sort((a, b) => a.path.compareTo(b.path));
    for (var file in fontFiles) {
      var future =
          file.readAsBytes().then((value) => value.buffer.asByteData());
      fontLoader.addFont(future);
    }
    await fontLoader.load();
  }
}

///By default, flutter test only uses a single "test" font called Ahem.
///
///This font is designed to show black spaces for every character and icon. This obviously makes goldens much less valuable.
///
///To make the goldens more useful, we will automatically load any fonts included in your pubspec.yaml as well as from
///packages you depend on.
Future<void> loadAppFonts(AssetBundle bundle) async {
  final fontManifest = await bundle.loadStructuredData<Iterable<dynamic>>(
    'FontManifest.json',
    (string) async => json.decode(string) as List,
  );

  for (var font in fontManifest.cast<Map<String, dynamic>>()) {
    var fontFamily = font['family'] as String;
    final fontLoader = FontLoader(fontFamily);
    for (final fontType
        in (font['fonts'] as List).cast<Map<String, dynamic>>()) {
      fontLoader.addFont(bundle.load(fontType['asset'] as String));
    }
    await fontLoader.load();
  }
}
