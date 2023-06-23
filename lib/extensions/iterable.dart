extension IterableExtention<E> on Iterable<E> {
  E? firstOrNull(bool Function(E element) predicate) {
    for (E element in this) {
      if (predicate(element)) return element;
    }
    return null;
  }

  Iterable<R> mapIndexed<R>(R Function(E element, int index) convert) sync* {
    var index = 0;
    for (var element in this) {
      yield convert(element, index++);
    }
  }
}

extension IterableNullableExtention<E> on Iterable<E?> {
  Iterable<E> filterNotNull() {
    return where((e) => e != null).map((e) => e!);
  }
}
