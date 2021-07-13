import 'dart:ui';

import 'package:flutter/material.dart';

final Color primaryColor = Color(0xffff8955);
final Color secondaryColor = Color(0xffff5500);
final Color backgroundColor = Color(0xffffffff);
final Color borderColor = Color(0xff9e9e9e);
final Color disabledColor = Color(0xff9e9e9e);
final Color overlayColor = Color(0x809e9e9e);

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
