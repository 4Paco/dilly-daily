import 'package:dilly_daily/models/QuantityEnum.dart';

class Ingredient {
  final String name;
  final double quantity;
  final QuantityUnit unit;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      quantity: (json['quantity'] as num).toDouble(),
      unit: QuantityUnit.fromString(json['unit']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "quantity": quantity,
      "unit": unit.name,
    };
  }
}
