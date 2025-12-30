enum QuantityUnit {
  gram,
  milliliter,
  piece;

  static QuantityUnit fromString(String value) {
    return QuantityUnit.values.firstWhere(
      (e) => e.name == value,
      orElse: () => QuantityUnit.gram,
    );
  }
}
