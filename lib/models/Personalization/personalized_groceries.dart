import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PersonalizedGroceries extends Iterable implements Iterator {
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
