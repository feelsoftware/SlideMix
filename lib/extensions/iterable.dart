extension IterableExtention<E> on Iterable<E> {
  E? firstOrNull(bool Function(E element) predicate) {
    for (E element in this) {
      if (predicate(element)) return element;
    }
    return null;
  }

  E max(num Function(E element) predicate) {
    return reduce((curr, next) => predicate(curr) > predicate(next) ? curr : next);
  }
}

extension IterableNullableExtention<E> on Iterable<E?> {
  Iterable<E> filterNotNull() {
    return where((e) => e != null).map((e) => e!);
  }
}
