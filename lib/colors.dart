import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const Color background = Color(0xffffffff);
  static const Color border = Color(0xff9e9e9e);
}

final Color primaryColor = Color(0xffff8955);
final Color secondaryColor = Color(0xffff5500);
final Color backgroundColor = AppColors.background;
final Color borderColor = AppColors.border;
final Color disabledColor = Color(0xff9e9e9e);
final Color overlayColor = Color(0x809e9e9e);
final Color statusBarColor = Color(0xffffffff);
final Color playerBackgroundColor = Color(0xff1d1d1b);

final SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle.dark.copyWith(
  statusBarColor: statusBarColor,
);
final SystemUiOverlayStyle playerSystemUiOverlayStyle =
    SystemUiOverlayStyle.dark.copyWith(
  statusBarColor: playerBackgroundColor,
  statusBarIconBrightness: Brightness.light,
);

final MaterialColor primarySwatch = MaterialColor(
  primaryColor.value,
  <int, Color>{
    50: primaryColor,
    100: primaryColor,
    200: primaryColor,
    300: primaryColor,
    400: primaryColor,
    500: primaryColor,
    600: primaryColor,
    700: primaryColor,
    800: primaryColor,
    900: primaryColor,
  },
);
