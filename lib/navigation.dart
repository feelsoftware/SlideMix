import 'package:flutter/material.dart';
import 'package:slidemix/logger.dart';

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

class NavigationLogger extends RouteObserver<Route<dynamic>> {
  @override
  void didPush(Route route, Route? previousRoute) {
    Logger.d('didPush ${_routeToLog(route)} ||| ${_routeToLog(previousRoute)}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    Logger.d('didReplace ${_routeToLog(newRoute)} ||| ${_routeToLog(oldRoute)}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    Logger.d('didPop ${_routeToLog(route)} ||| ${_routeToLog(previousRoute)}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    Logger.d('didRemove ${_routeToLog(route)} ||| ${_routeToLog(previousRoute)}');
  }

  String _routeToLog(Route<dynamic>? route) {
    if (route == null) return '';
    return <String>[
      "'${route.settings.name}'" ?? '/',
      if (route.settings.arguments != null) "arguments:{${route.settings.arguments.toString()}}",
    ].join(' ');
  }
}
