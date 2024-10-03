import 'package:flutter/widgets.dart';
import '../../../../core/scenario_models.dart';

export '../../../../core/scenario_models.dart';

extension DevicePlatformExtension on DevicePlatform {
  TargetPlatform toTargetPlatform() {
    switch (this) {
      case DevicePlatform.android:
        return TargetPlatform.android;
      case DevicePlatform.iOS:
        return TargetPlatform.iOS;
      case DevicePlatform.macOS:
        return TargetPlatform.macOS;
      case DevicePlatform.windows:
        return TargetPlatform.windows;
      case DevicePlatform.linux:
        return TargetPlatform.linux;
    }
    throw StateError('Unknown platform $this');
  }
}

extension RectangleExtension on Rectangle {
  EdgeInsets toEdgeInsets() => EdgeInsets.fromLTRB(left, top, right, bottom);
}
