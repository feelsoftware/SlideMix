import 'package:flutter/material.dart';

class AppRouteSettings extends RouteSettings {
  final String routeName;
  final Type screenClass;

  AppRouteSettings({
    required this.routeName,
    required this.screenClass,
    Map<String, Object>? arguments,
  }) : super(
          name: routeName,
          arguments: <String, Object>{
            'screenClass': screenClass.toString(),
          }..addAll(arguments ?? {}),
        );
}

class ScreenRoute<T> extends MaterialPageRoute<T> {
  ScreenRoute({
    required RouteSettings settings,
    required Widget child,
  }) : super(settings: settings, builder: (_) => child);

  @override
  Duration get transitionDuration => Duration.zero;
}

/// Contains information about the current navigation stack.
class NavigationStackObserver extends RouteObserver<Route<dynamic>> {
  static final _stack = <Route<dynamic>>[];

  static Iterable<Route<dynamic>> get stack => List.unmodifiable(_stack);

  @override
  void didPush(Route route, Route? previousRoute) {
    if (_stack.any((e) => e.settings.name == route.settings.name)) {
      // There is already this route in the stack, remove old position and insert at end
      _remove(route);
      return;
    }

    _stack.add(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (oldRoute != null) {
      _remove(oldRoute);
    }
    if (newRoute != null) {
      _stack.add(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    _remove(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);

    _remove(route);
  }

  void _remove(Route<dynamic> route) {
    _stack.removeWhere((e) => e.settings.name == route.settings.name);
  }
}
