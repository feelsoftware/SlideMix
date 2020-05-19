import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/foundation.dart';

class ViewModel extends ChangeNotifier {
  final Random _random = Random.secure();
  final Map<int, StreamSubscription<Object>> _subscriptions = Map();

  @protected
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  @protected
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  ///
  /// Launch this [action] asynchronously and invoke [result] after execution.
  ///
  void launch<T extends Object>(Future<T> action(), void result(T data),
      {Function onError}) {
    final key = _generateSubscriptionKey();
    _subscriptions.putIfAbsent(key, () {
      return action()
          .then(
            (value) {
              result(value);
            },
            onError: (error) {
              onError(error);
            },
          )
          .asStream()
          .listen((event) {
            _subscriptions.remove(key);
          });
    });
  }

  ///
  /// Subscribe to Stream from [action] and invoke [result] for each change.
  ///
  void listen<T extends Object>(Stream<T> action(), void result(T data),
      {Function onError}) {
    final key = _generateSubscriptionKey();
    _subscriptions.putIfAbsent(key, () {
      return action().listen((data) {
        result(data);
      }, onError: (error) {
        onError(error);
      }, onDone: () {
        _subscriptions.remove(key);
      });
    });
  }

  @mustCallSuper
  void dispose() {
    super.dispose();
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
