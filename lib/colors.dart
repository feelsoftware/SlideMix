import 'dart:ui';

import 'package:flutter/material.dart';

final Color primaryColor = Color(0xffff8955);
final Color secondaryColor = Color(0xffff5500);
final Color borderColor = Color(0xff9e9e9e);

final MaterialColor primarySwatch = MaterialColor(
  primaryColor.value,
  <int, Color>{
    50: Color(primaryColor.value),
    100: Color(primaryColor.value),
    200: Color(primaryColor.value),
    300: Color(primaryColor.value),
    400: Color(primaryColor.value),
    500: Color(primaryColor.value),
    600: Color(primaryColor.value),
    700: Color(primaryColor.value),
    800: Color(primaryColor.value),
    900: Color(primaryColor.value),
  },
);
