import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

export 'package:logging/logging.dart' show Level;

/// Register to prints all the logs from the Loggers (at the specified level).
/// This could be useful during debugging of the tests.
/// However it should always be turned off before committing the test.
/// A good workflow can be to create a second non-versioned file to turn-on
/// the logger and run a specific test for debugging.
void setupDebugLogger({Level? level}) {
  Logger.root
    ..level = level ?? Level.ALL
    ..onRecord.listen((e) {
      var errorSuffix = '';
      if (e.error != null) {
        errorSuffix = ' (${e.error})';
      }

      debugPrint('[${e.level.name}] ${e.loggerName}: ${e.message}$errorSuffix');

      if (e.stackTrace != null) {
        debugPrint('${e.stackTrace}');
      }
    });
}
