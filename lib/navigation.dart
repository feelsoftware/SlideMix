import 'package:flutter/material.dart';

class ScreenRoute<T> extends MaterialPageRoute<T> {
  ScreenRoute(Widget child) : super(builder: (_) => child);

  @override
  Duration get transitionDuration => Duration.zero;
}
