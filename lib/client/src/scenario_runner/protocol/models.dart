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
    }
    throw StateError('Unknown platform $this');
  }
}

extension RectangleExtension on Rectangle {
  EdgeInsets toEdgeInsets() => EdgeInsets.fromLTRB(left, top, right, bottom);
}
