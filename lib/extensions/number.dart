extension DoubleX on double {
  double toPrecision({required int digits}) {
    return double.parse(toStringAsFixed(digits));
  }
}
