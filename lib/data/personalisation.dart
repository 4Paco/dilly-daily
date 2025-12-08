import 'dart:convert';
import 'dart:io';

import 'package:dilly_daily/models/Recipie.dart';
import 'package:path_provider/path_provider.dart';

Allergies allergiesList = Allergies();
Groceries listeCourses = Groceries();
PersonalizedGroceries coursesPersonnelles = PersonalizedGroceries();
MyRecipes myRecipes = MyRecipes();

class Allergies extends Iterable with Iterator {
  Map<String, bool> _allergiesDict = {};

  int get limit => _allergiesDict.keys.length;
  int i = 0;

  @override
  int get current => i;

  @override
  bool moveNext() {
    i++;
    return i <= limit;
  }

  @override
  Iterator get iterator => _allergiesDict.keys.iterator;

  @override
  bool get isNotEmpty => _allergiesDict.isNotEmpty;
  @override
  bool get isEmpty => _allergiesDict.isEmpty;

  Allergies() {
    _allergiesDict = {};
    load();
  }

  bool? operator [](String ingredient) {
    return _allergiesDict[ingredient];
  }

  Future<void> load() async {
    await ensureFileExists();
    final file = await _localFile;
    // Read the file
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);
    for (String key in json.keys) {
      _allergiesDict[key] = json[key] as bool;
    }
  }

  Future<bool> isLoaded() async {
    if (_allergiesDict.isEmpty) {
      await load();
    }
    return _allergiesDict.isNotEmpty;
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/allergies.json');
  }

  Future<void> ensureFileExists() async {
    final file = await _localFile;

    // Check if the file exists
    if (!(await file.exists())) {
      // Create the file with default content
      await file.writeAsString(jsonEncode({})); // Empty JSON object as default
    } else {}
  }

  Future<void> updateJson() async {
    final filePath = await _localFile;
    final json = _allergiesDict.map((key, value) => MapEntry(key, value));
    String jsonString = jsonEncode(json);
    filePath.writeAsString(jsonString);
  }

  void addIngredient(String ingredient) {
    if (!_allergiesDict.keys.contains(ingredient)) {
      _allergiesDict[ingredient] = true;
    }
    updateJson();
  }

  void setIntensity(String ingredient, bool value) {
    if (_allergiesDict.keys.contains(ingredient)) {
      _allergiesDict[ingredient] = value;
    }
    updateJson();
  }

  void removeIngredient(String ingredient) {
    if (_allergiesDict.keys.contains(ingredient)) {
      _allergiesDict.remove(ingredient);
    }
    updateJson();
  }

  List<String> getDislikes() {
    List<String> liste = [];
    for (var key in _allergiesDict.keys) {
      if (!_allergiesDict[key]!) {
        liste.add(key);
      }
    }
    return liste;
  }

  List<String> getForbidden() {
    List<String> liste = [];
    for (var key in _allergiesDict.keys) {
      if (_allergiesDict[key]!) {
        liste.add(key);
      }
    }
    return liste;
  }
}

class Groceries extends Iterable with Iterator {
  Map<String, double> _groceriesDict = {};
  Map<String, double> _extendedGroceriesDict = {};

  int get limit => _groceriesDict.keys.length;
  int i = 0;
  @override
  int get current => i;
  @override
  bool moveNext() {
    i++;
    return i <= limit;
  }

  @override
  Iterator get iterator => _groceriesDict.keys.iterator;

  @override
  bool get isNotEmpty => _groceriesDict.isNotEmpty;
  @override
  bool get isEmpty => _extendedGroceriesDict.isEmpty;
  @override
  bool contains(Object? element) {
    return _groceriesDict.containsKey(element);
  }

  bool appearsInList(String element) {
    return _extendedGroceriesDict.containsKey(element);
  }

  Map<String, double?> copyDict() {
    return Map.from(_groceriesDict);
  }

  Groceries() {
    _groceriesDict = {};
    load();
  }

  double? operator [](String ingredient) {
    return _extendedGroceriesDict[ingredient];
  }

  Future<void> load() async {
    await ensureFileExists();
    final file = await _localFile;
    // Read the file
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);
    for (String key in json.keys) {
      _groceriesDict[key] = json[key] as double;
    }
    _extendedGroceriesDict = Map.from(_groceriesDict);
  }

  Future<bool> isLoaded() async {
    if (_groceriesDict.isEmpty) {
      await load();
    }
    return _groceriesDict.isNotEmpty;
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/groceries.json');
  }

  Future<void> ensureFileExists() async {
    final file = await _localFile;

    // Check if the file exists
    if (!(await file.exists())) {
      // Create the file with default content
      await file.writeAsString(jsonEncode({})); // Empty JSON object as default
    } else {}
  }

  Future<void> updateJson() async {
    final filePath = await _localFile;
    final json = _groceriesDict.map((key, value) => MapEntry(key, value));
    String jsonString = jsonEncode(json);
    filePath.writeAsString(jsonString);
  }

  void addIngredient(String ingredient, double? qtt) {
    if (_groceriesDict.containsKey(ingredient)) {
      _groceriesDict[ingredient] =
          (_groceriesDict[ingredient] ?? 0) + (qtt ?? 0);
      _extendedGroceriesDict[ingredient] = (_groceriesDict[ingredient] ?? 0);
    } else {
      _groceriesDict[ingredient] = (qtt ?? 0);
      _extendedGroceriesDict[ingredient] = (qtt ?? 0);
    }
    updateJson();
  }

  void toggleIngredient(String ingredient) {
    if (isIngredientChecked(ingredient)) {
      _groceriesDict[ingredient] = (_extendedGroceriesDict[ingredient] ?? 0);
    } else {
      removeIngredient(ingredient);
    }
  }

  void removeIngredient(String ingredient) {
    if (_groceriesDict.keys.contains(ingredient)) {
      _groceriesDict.remove(ingredient);
    }
    updateJson();
  }

  void forceRemoveIngredient(String ingredient) {
    if (_groceriesDict.keys.contains(ingredient)) {
      _groceriesDict.remove(ingredient);
    }
    if (_extendedGroceriesDict.keys.contains(ingredient)) {
      _extendedGroceriesDict.remove(ingredient);
    }
    updateJson();
  }

  bool isIngredientChecked(String ingredient) {
    return (!_groceriesDict.containsKey(ingredient) &&
        _extendedGroceriesDict.containsKey(ingredient));
  }

  List<String> getIngredients() {
    return List.from(_groceriesDict.keys);
  }

  Map<String, double> getExtended() {
    return Map.from(_extendedGroceriesDict);
  }
}

class PersonalizedGroceries extends Iterable with Iterator {
  Set<String> _groceriesList = {};
  Set<String> _extendedGroceriesDict = {};

  int get limit => _groceriesList.length;
  int i = 0;
  @override
  int get current => i;
  @override
  bool moveNext() {
    i++;
    return i <= limit;
  }

  @override
  Iterator get iterator => _groceriesList.iterator;

  @override
  bool get isNotEmpty => _groceriesList.isNotEmpty;
  @override
  bool get isEmpty => _extendedGroceriesDict.isEmpty;
  @override
  bool contains(Object? element) {
    return _groceriesList.contains(element);
  }

  Set<String> copyList() {
    return Set.from(_groceriesList);
  }

  PersonalizedGroceries() {
    _groceriesList = {};
    load();
  }

  Future<void> load() async {
    await ensureFileExists();
    final file = await _localFile;
    // Read the file
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);
    var workingJson = List.from(json.keys);
    if (json.isEmpty) {
      workingJson = [
        "Mozza",
        "Raisin",
        "Jambon",
        "Oeufs",
        "Chocolat",
        "PQ",
        "Petit-dej",
        "Jus de fruit",
        "Légumes",
        "Sacs poubelle",
        "Pâtes"
      ];
    }
    for (String elmt in workingJson) {
      _groceriesList.add(elmt);
    }
    _extendedGroceriesDict = Set.from(_groceriesList);
  }

  Future<bool> isLoaded() async {
    if (_groceriesList.isEmpty) {
      await load();
    }
    return _groceriesList.isNotEmpty;
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/personalized_groceries.json');
  }

  Future<void> ensureFileExists() async {
    final file = await _localFile;

    // Check if the file exists
    if (!(await file.exists())) {
      // Create the file with default content
      await file.writeAsString(jsonEncode({})); // Empty JSON object as default
    } else {}
  }

  Future<void> updateJson() async {
    final filePath = await _localFile;
    String jsonString = jsonEncode(_groceriesList);
    filePath.writeAsString(jsonString);
  }

  void addIngredient(String ingredient) {
    if (!_groceriesList.contains(ingredient)) {
      _groceriesList.add(ingredient);
      _extendedGroceriesDict.add(ingredient);
    }
    updateJson();
  }

  //void toggleIngredient(String ingredient) {
  //  if (isIngredientChecked(ingredient)) {
  //    _groceriesList[ingredient] = (_extendedGroceriesDict[ingredient] ?? 0);
  //  } else {
  //    removeIngredient(ingredient);
  //  }
  //}

  void removeIngredient(String ingredient) {
    if (_groceriesList.contains(ingredient)) {
      _groceriesList.remove(ingredient);
    }
    updateJson();
  }

  bool isIngredientChecked(String ingredient) {
    return (!_groceriesList.contains(ingredient) &&
        _extendedGroceriesDict.contains(ingredient));
  }

  Set<String> getIngredients() {
    return Set.from(_groceriesList);
  }

  Set<String> getExtended() {
    return Set.from(_extendedGroceriesDict);
  }
}

//class Recipe {
//  String name;
//  String image;
//  int servings;
//  int readyInMinutes;
//  int cookingMinutes;
//  int preparationMinutes;
//  String personalized;
//  String recipeLink;
//  List<String> steps;
//  Map<String, double> ingredients;
//  List<String> dishTypes;
//  String summary;

//  Recipe({
//    this.name = "",
//    this.summary = "",
//    this.personalized = "Nope",
//    this.recipeLink = "",
//    this.image = "",
//    this.dishTypes = const ["Meal"],
//    this.servings = 1,
//    this.readyInMinutes = -1,
//    this.preparationMinutes = -1,
//    this.cookingMinutes = -1,
//    this.ingredients = const {},
//    this.steps = const [],
//  }) {
//    if (servings > 1) {
//      ingredients = Map.unmodifiable(
//        ingredients.map((key, value) => MapEntry(key, value / servings)),
//      );
//    }
//  }

//  Recipe.fromJson(Map<String, dynamic> json)
//      : name = json['name'],
//        image = json['image'],
//        servings = json['servings'],
//        readyInMinutes = json['readyInMinutes'],
//        cookingMinutes = json['cookingMinutes'],
//        preparationMinutes = json['preparationMinutes'],
//        personalized = json['personalized'],
//        recipeLink = json['recipeLink'],
//        steps = List<String>.from(json["steps"]),
//        ingredients = Map<String, double>.from(json['ingredients']),
//        dishTypes = List<String>.from(json['dishTypes']),
//        summary = json['summary'];

//  Map<String, dynamic> toJson() {
//    print("toJson called");
//    return {
//      'name': name,
//      'image': image,
//      'servings': servings,
//      'readyInMinutes': readyInMinutes,
//      'cookingMinutes': cookingMinutes,
//      'preparationMinutes': preparationMinutes,
//      'personalized': personalized,
//      'recipeLink': recipeLink,
//      'steps': steps,
//      'ingredients': ingredients,
//      'dishTypes': dishTypes,
//      'summary': summary,
//    };
//  }

//  @override
//  bool operator ==(Object other) {
//    if (identical(this, other)) return true;
//    if (other is! Recipe) return false;
//    print("full test to compare this $name to ${other.name}");
//    Recipe recette = other;
//    print(
//        "names of this / recette / other : {$name}/{${recette.name}}/{${other.name}}");
//    //if (name == recette.name) {
//    //  print("same name");
//    //  if (image == recette.image) {
//    //    print("same image");
//    //    if (servings == recette.servings) {
//    //      print("same servings");
//    //      if (readyInMinutes == recette.readyInMinutes) {
//    //        print("same readyInMinutes");
//    //        if (cookingMinutes == recette.cookingMinutes) {
//    //          print("same cooking minutes");
//    //          if (preparationMinutes == recette.preparationMinutes) {
//    //            print("same prep min");
//    //            if (personalized == recette.personalized) {
//    //              print("same personalized");
//    //              if (recipeLink == recette.recipeLink) {
//    //                print("same link");
//    //                if (steps.toString() == recette.steps.toString()) {
//    //                  print("same steps");
//    //                  if (ingredients.toString() ==
//    //                      recette.ingredients.toString()) {
//    //                    print("same ingredients");
//    //                    if (dishTypes.toString() ==
//    //                        recette.dishTypes.toString()) {
//    //                      print("same dish types");
//    //                      if (summary == recette.summary) {
//    //                        print("same summary");
//    //                      }
//    //                    }
//    //                  }
//    //                }
//    //              }
//    //            }
//    //          }
//    //        }
//    //      }
//    //    }
//    //  }
//    //}

//    return name == recette.name &&
//        image == recette.image &&
//        servings == recette.servings &&
//        readyInMinutes == recette.readyInMinutes &&
//        cookingMinutes == recette.cookingMinutes &&
//        preparationMinutes == recette.preparationMinutes &&
//        personalized == recette.personalized &&
//        recipeLink == recette.recipeLink &&
//        steps.toString() == recette.steps.toString() &&
//        ingredients.toString() == recette.ingredients.toString() &&
//        dishTypes.toString() == recette.dishTypes.toString() &&
//        summary == recette.summary;
//  }

//  @override
//  int get hashCode => Object.hash(name, ingredients, summary);

//  String get id => Uuid().v4();
//}

class MyRecipes extends Iterable with Iterator {
  Map<String, Recipe> _recipesDict = {};

  MyRecipes({this.recipeFile = "my_recipes"}) {
    _recipesDict = {};
    load();
  }

  // Functional overrides
  // // Use as iterator
  int get limit => _recipesDict.keys.length;
  int i = 0;
  String recipeFile;
  @override
  int get current => i;
  @override
  bool moveNext() {
    i++;
    return i <= limit;
  }

  @override
  Iterator get iterator => _recipesDict.keys.iterator;

  // // Use as dict
  Recipe? operator [](String key) {
    return _recipesDict[key];
  }

  bool containsKey(String key) {
    return _recipesDict.containsKey(key);
  }

  @override
  bool get isNotEmpty => _recipesDict.isNotEmpty;
  @override
  bool get isEmpty => _recipesDict.isEmpty;

  // // Copy keys
  @override
  List<String> toList({bool growable = true}) {
    return _recipesDict.keys.toList(growable: growable);
  }

  // General json handling
  Future<void> load() async {
    await ensureFileExists();
    final file = await _localFile;
    // Read the file
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString);
    for (String key in data.keys) {
      String id = key; //int.parse(key);
      _recipesDict[id] = Recipe.fromJson(int.parse(key), data[key]);
    }
  }

  Future<bool> isLoaded() async {
    if (_recipesDict.isEmpty) {
      await load();
    }
    return _recipesDict.isNotEmpty;
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$recipeFile.json');
  }

  Future<void> ensureFileExists() async {
    final file = await _localFile;

    // Check if the file exists
    if (!(await file.exists())) {
      // Create the file with default content
      await file.writeAsString(jsonEncode({})); // Empty JSON object as default
    } else {}
  }

  Future<void> updateJson() async {
    print("updating MyRecipes JSON");
    final filePath = await _localFile;
    final json =
        _recipesDict.map((key, value) => MapEntry(key, value.toJson()));
    String jsonString = jsonEncode(json);
    filePath.writeAsString(jsonString);
  }

  void addRecipe(Recipe recette, {String recipeKey = ""}) {
    String key = recipeKey.toString();
    if (recipeKey.isEmpty) {
      key = recette.id;
    }
    //print(
    //    "DICT VALUES : ${_recipesDict.map((key, value) => MapEntry(key.toString(), value.name))}");
    //int newKey = recette.hashCode;
    //_recipesDict[newKey] = recette;
    //print("${recette.name} has been added to meal plan dict");
    _recipesDict[key] = recette;
    updateJson();
  }

  void removeRecipe(String recipeKey) {
    //print(
    //    "DICT VALUES : ${_recipesDict.map((key, value) => MapEntry(key.toString(), value.name))}");
    if (_recipesDict.containsKey(recipeKey)) {
      print(
          "${_recipesDict[recipeKey]!.name} has been removed from meal plan dict");
      _recipesDict.remove(recipeKey);
    } else {
      throw ArgumentError(
          "No such recipe in dict with this ID. Removal aborted");
    }
    //if (_recipesDict.containsValue(recette)) {
    //  _recipesDict.removeWhere((key, value) => value == recette);
    //  print("${recette.name} has been removed from meal plan dict");
    //} else {
    //  throw ArgumentError(
    //      "No such recipe in dict with this ID. Removal aborted");
    //}
    updateJson();
  }
}

int defaultPersonNumber = 1;

double patience = 0.5;

List<String> favoriteRecipes = [];

MyRecipes mealPlanRecipes = MyRecipes(recipeFile: "meal_plan_recipes");

List<List<String>> weekMeals = [
  ["", ""],
  ["", ""],
  ["", ""],
  ["", ""],
  ["", ""],
  ["", ""],
  ["", ""]
];
