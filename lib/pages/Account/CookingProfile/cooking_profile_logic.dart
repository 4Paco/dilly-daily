import 'dart:math';

int clampPortionCount(int current, int delta) {
  return max(1, current + delta);
}

double normalizePatience(double value) {
  final rounded = (value * 10).roundToDouble() / 10;
  return max(0.1, min(0.9, rounded));
}
