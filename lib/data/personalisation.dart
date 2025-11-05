import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Allergies allergiesList = Allergies();
Groceries listeCourses = Groceries();
PersonalizedGroceries coursesPersonnelles = PersonalizedGroceries();

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
    print("Loading");
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
    print("add $ingredient called");
    if (!_allergiesDict.keys.contains(ingredient)) {
      print("$ingredient added");
      _allergiesDict[ingredient] = true;
    }
    updateJson();
    print("json updated with $ingredient");
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
    print("Loading");
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
    print("Loading");
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

int defaultPersonNumber = 1;

double patience = 0.5;

List<int> favoriteRecipes = [1, 2, 3, 4, 5];

List<int> mealPlanList = [716429];

List<List<int>> weekMeals = [
  [-1, -1],
  [-1, -1],
  [-1, -1],
  [-1, -1],
  [-1, -1],
  [-1, -1],
  [-1, -1]
];
