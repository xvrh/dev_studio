import 'package:dev_studio_core/scenario_models.dart';
import 'package:flutter/widgets.dart';

export 'package:dev_studio_core/scenario_models.dart';

extension DevicePlatformExtension on DevicePlatform {
  TargetPlatform toTargetPlatform() {
    switch (this) {
      case DevicePlatform.android:
        return TargetPlatform.android;
      case DevicePlatform.iOS:
        return TargetPlatform.iOS;
    }
    throw StateError('Unknown platform $this');
  }
}

extension RectangleExtension on Rectangle {
  EdgeInsets toEdgeInsets() => EdgeInsets.fromLTRB(left, top, right, bottom);
}
