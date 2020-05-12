import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/foundation.dart';

class ViewModel {
  final Random _random = Random.secure();
  final Map<int, StreamSubscription<Object>> _subscriptions = Map();

  void launch<T extends Object>(Future<T> action(), void result(T data)) {
    final key = _generateSubscriptionKey();
    _subscriptions.putIfAbsent(key, () {
      return action().asStream().listen((data) {
        result(data);
        _subscriptions.remove(key);
      });
    });
  }

  void listen<T extends Object>(Stream<T> action(), void result(T data)) {
    final key = _generateSubscriptionKey();
    _subscriptions.putIfAbsent(key, () {
      return action().listen((data) {
        result(data);
      }, onDone: () {
        _subscriptions.remove(key);
      });
    });
  }

  @mustCallSuper
  void dispose() {
    _subscriptions.values.forEach((item) {
      item.cancel();
    });
    _subscriptions.clear();
  }

  int _generateSubscriptionKey() {
    var key = 0;
    while (_subscriptions.containsKey(key)) {
      key = _random.nextInt(Int32().hashCode);
    }
    return key;
  }
}
