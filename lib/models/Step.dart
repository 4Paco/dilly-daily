import 'package:dilly_daily/models/Ingredient.dart';

enum StepType { preparation, cooking }

class Step {
  final String description;
  final Duration? duration;
  final StepType type;
  final List<Ingredient> ingredients;

  Step({
    this.description = "",
    this.duration,
    this.type = StepType.preparation,
    this.ingredients = const [],
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      description: json['description'] as String,
      duration: json['duration'] != null
          ? Duration(minutes: json['duration'])
          : null,
      type: StepType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => StepType.preparation,
      ),
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
              .map((i) => Ingredient.fromJson(i))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "duration": duration?.inMinutes,
      "type": type.name,
      "ingredients": ingredients.map((i) => i.toJson()).toList(),
    };
  }

  String formattedDuration() {
    if (duration == null) return "-";
    final total = duration!.inMinutes;

    if (total < 60) return "$total min";
    final h = total ~/ 60;
    final m = total % 60;
    return m == 0 ? "${h}h" : "${h}h$m";
  }

  @override
  String toString() =>
      'Step(description: "$description", duration: ${duration?.inMinutes}, type: $type, ingredients: $ingredients)';
}
