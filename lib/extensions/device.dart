import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

extension BuildContextX on BuildContext {
  DeviceType get deviceType => SizerUtil.deviceType == sizer.DeviceType.mobile
      ? DeviceType.mobile
      : DeviceType.tablet;

  Orientation get deviceOrientation => SizerUtil.orientation;
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
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (_, __, ___) => child);
  }
}