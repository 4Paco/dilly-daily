import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class Groceries extends Iterable implements Iterator {
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
    if (!kIsWeb) {
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

  // NOUVELLE FONCTION : Vide complètement la liste de courses
  void clearAll() {
    _groceriesDict.clear();
    _extendedGroceriesDict.clear();
    updateJson();
  }
}
