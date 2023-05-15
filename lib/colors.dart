import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const Color primary = Color(0xffff8955);
  static const Color secondary = Color(0xffff5500);

  static const Color background = Color(0xffffffff);
  static const Color statusBar = Colors.transparent;
  static const Color disabled = Color(0xff9e9e9e);
  static const Color border = Color(0xff9e9e9e);
  static const Color overlay = Color(0x809e9e9e);
  static const Color playerBackground = Color(0xff1d1d1b);
  static const Color error = Color(0xffff0000);

  AppColors._();
}

final SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle.dark.copyWith(
  statusBarColor: AppColors.statusBar,
  statusBarIconBrightness: Brightness.dark,
);
// final SystemUiOverlayStyle welcomeSystemUiOverlayStyle =
//     SystemUiOverlayStyle.dark.copyWith(
//   statusBarColor: Colors.transparent,
//   statusBarIconBrightness: Brightness.light,
// );
// final SystemUiOverlayStyle playerSystemUiOverlayStyle =
//     SystemUiOverlayStyle.dark.copyWith(
//   statusBarColor: AppColors.playerBackground,
//   statusBarIconBrightness: Brightness.light,
// );

final MaterialColor primarySwatch = MaterialColor(
  AppColors.primary.value,
  const <int, Color>{
    50: AppColors.primary,
    100: AppColors.primary,
    200: AppColors.primary,
    300: AppColors.primary,
    400: AppColors.primary,
    500: AppColors.primary,
    600: AppColors.primary,
    700: AppColors.primary,
    800: AppColors.primary,
    900: AppColors.primary,
  },
);
