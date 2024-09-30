import 'package:flutter/widgets.dart';
import '../../client/logger_utils.dart';

void runDebugApp(Widget widget) {
  setupDebugLogger();

  // IMPORTANTE NOTE: if we wrap the runApp call in a runZoneGuarded,
  // we should never call WidgetsFlutterBinding.ensureInitialized() outside
  // of this callback
  runApp(widget);
}
