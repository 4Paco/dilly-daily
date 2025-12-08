import 'dart:convert';
import 'dart:io';
import 'package:dilly_daily/models/Recipie.dart';
import 'package:path_provider/path_provider.dart';

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
    int key = int.parse(recipeKey);
    if (recipeKey.isEmpty) {
      key = recette.id;
    }
    //print(
    //    "DICT VALUES : ${_recipesDict.map((key, value) => MapEntry(key.toString(), value.name))}");
    //int newKey = recette.hashCode;
    //_recipesDict[newKey] = recette;
    //print("${recette.name} has been added to meal plan dict");
    _recipesDict[key.toString()] = recette;
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
