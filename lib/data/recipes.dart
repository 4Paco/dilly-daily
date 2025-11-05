import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

Recipes recipesDict = Recipes();

class Recipes extends Iterable with Iterator {
  Map<int, dynamic> _recipesDict = {};

  int get limit => _recipesDict.keys.length;
  int i = 0;
  @override
  int get current => i;
  @override
  bool moveNext() {
    i++;
    return i <= limit;
  }

  @override
  Iterator get iterator => _recipesDict.keys.iterator;

  Recipes() {
    _recipesDict = {};
    load();
  }

  Future<void> load() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/recipes.json');
    final data = jsonDecode(jsonString);
    for (String key in data.keys) {
      int id = int.parse(key);
      _recipesDict[id] = data[key];
    }
  }

  Future<bool> isLoaded() async {
    if (_recipesDict.isEmpty) {
      await load();
    }
    return _recipesDict.isNotEmpty;
  }

  Map? operator [](int recipe) {
    return _recipesDict[recipe];
  }

  @override
  List<int> toList({bool growable = true}) {
    return _recipesDict.keys.toList(growable: growable);
  }
}
