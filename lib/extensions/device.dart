import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

extension BuildContextX on BuildContext {
  DeviceType get deviceType => Device.screenType == sizer.ScreenType.mobile
      ? DeviceType.mobile
      : DeviceType.tablet;

  Orientation get deviceOrientation => sizer.Device.orientation;
}

extension DeviceTypeX on DeviceType {
  bool get isMobile => this == DeviceType.mobile;

  bool get isTablet => this == DeviceType.tablet;
}

extension OrientationX on Orientation {
  bool get isPortrait => this == Orientation.portrait;

  bool get isLandscape => this == Orientation.landscape;
}

enum DeviceType {
  mobile,
  tablet,
}

class DeviceTypeContainer extends StatelessWidget {
  final Widget child;

  const DeviceTypeContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (_, __, ___) => child);
  }
}
