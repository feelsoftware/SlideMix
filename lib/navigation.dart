import 'package:flutter/material.dart';

class ScreenRoute<T> extends MaterialPageRoute<T> {
  ScreenRoute(Widget child) : super(builder: (_) => child);

  @override
  Duration get transitionDuration => Duration.zero;
}

/// Contains information about the current navigation stack.
class NavigationStackObserver extends RouteObserver<Route<dynamic>> {
  static final _stack = <Route<dynamic>>[];

  static Iterable<Route<dynamic>> get stack => List.unmodifiable(_stack);

  static Route<dynamic>? get activeRoute =>
      _stack.isNotEmpty ? _stack[_stack.length - 1] : null;

  // region DialogRoute
  static bool get _hasActiveDialogs =>
      _stack.any((route) => route is DialogRoute<dynamic>);

  // The [Future] is completed when there is no active dialogs, otherwise it's pending.
  static Future<T> executeWhenNoDialogs<T>(T Function() block) async {
    while (_hasActiveDialogs) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    return block();
  }

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
