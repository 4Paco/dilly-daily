import 'Step.dart';

class Recipe {
  int id;
  String name;
  String image;
  String personalized;
  List<Step> steps;
  Map<String, double> ingredients;
  String summary;

  // main constructor
  Recipe({
    required this.id,
    required this.name,
    required this.summary,
    required this.steps,
    required this.ingredients,
    this.personalized = "Nope",
    this.image = ""
  });

  // named constructor
  Recipe.fromJson(int jsonId, Map<String, dynamic> json)
      : id = jsonId,
        name = json['name'],
        image = json['image'] ?? "",
        personalized = json['personalized'] ?? "Nope",
        summary = json['summary'] ?? "",
        ingredients = json['ingredients'] != null
            ? Map<String, double>.from(json['ingredients'])
            : {},
        steps = json['steps'] != null
            ? (json['steps'] as List)
                .map((item) => Step.fromJson(item))
                .toList()
            : [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'personalized': personalized,
      'steps': steps.map((s) => s.toJson()).toList(),
      'ingredients': ingredients,
      'summary': summary,
    };
  }
}
