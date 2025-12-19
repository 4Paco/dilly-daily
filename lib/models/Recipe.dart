import 'package:uuid/uuid.dart';

import 'Step.dart';

class Recipe {
  String id;
  String name;
  String image;
  String personalized;
  List<Step> steps;
  Map<String, double> ingredients;
  List<String> necessaryGear;
  String summary;
  int servings;
  String recipeLink;
  List<String> dishTypes;

  // main constructor
  Recipe(
      {this.name = "",
      String? id,
      this.summary = "",
      this.steps = const [],
      this.ingredients = const {},
      this.necessaryGear = const [],
      this.personalized = "Nope",
      this.recipeLink = "",
      this.dishTypes = const [],
      this.servings = 1,
      this.image = ""})
      : id = id ?? Uuid().v4();

  static String generateId() {
    return Uuid().v4();
  }

  // named constructor
  Recipe.fromJson(String jsonId, Map<String, dynamic> json)
      : id = jsonId,
        name = json['name'],
        image = json['image'] ?? "",
        personalized = json['personalized'] ?? "Nope",
        summary = json['summary'] ?? "",
        ingredients = json['ingredients'] != null
            ? Map<String, double>.from(json['ingredients']
                .map((key, value) => MapEntry(key, (value as num).toDouble())))
            : {},
        necessaryGear = List<String>.from(json['gear'] ?? []),
        steps = json['steps'] != null
            ? (json['steps'] as List)
                .map((item) => Step.fromJson(item))
                .toList()
            : [],
        servings = json['servings'] ?? 1,
        recipeLink = json['recipeLink'] ?? "",
        dishTypes = List<String>.from(json['dishTypes'] ?? []);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (recipeLink.isNotEmpty) 'recipeLink': recipeLink,
      if (image != "") 'image': image,
      if (servings > 1) 'servings': servings,
      if (dishTypes.isNotEmpty) 'dishTypes': dishTypes,
      if (necessaryGear.isNotEmpty) 'gear': necessaryGear,
      if (personalized != "Nope") 'personalized': personalized,
      'steps': steps.map((s) => s.toJson()).toList(),
      'ingredients': ingredients,
      'summary': summary,
    };
  }

  /// Returns total duration of recipe by summing durations of all steps
  Duration duration() {
    final totalMinutes = steps.fold<int>(
      0,
      (prev, step) => prev + (step.duration?.inMinutes ?? 0),
    );

    return Duration(minutes: totalMinutes);
  }
}
