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

    final totalMin = duration!.inMinutes;

    if (totalMin < 60) {
      return "$totalMin min";
    }

    final hours = totalMin ~/ 60;
    final remaining = totalMin % 60;

    return remaining == 0 ? "${hours}h" : "${hours}h$remaining";
  }

  @override
  String toString() =>
      'Step(description: "$description", duration: ${duration?.inMinutes} min, type: $type)';

  Step copy({
    String? description,
    Duration? duration,
    StepType? type,
  }) {
    return Step(
      description: description ?? this.description,
      duration: duration ?? this.duration,
      type: type ?? this.type,
    );
  }
}
