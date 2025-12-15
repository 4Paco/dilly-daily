import 'dart:collection' show ListBase;
import 'dart:convert';
import 'dart:io';

import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Personalization/my_recipes.dart'
    show MyRecipes;
import 'package:path_provider/path_provider.dart';

class PetitesMerles {
  int _defaultPersonNumber = 0;
  double _patience = 0.5;
  List<String> _favoriteRecipes = [];
  List<List<String>> _weekMeals = [
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""]
  ];
  final MyRecipes _myRecipes;

  PetitesMerles({
    required MyRecipes myRecipes,
  }) : _myRecipes = myRecipes {
    load();
    _myRecipes.addListener(_cleanOrphanedRecipeIds);
  }

  void _cleanOrphanedRecipeIds() {
    bool hasChanges = false;

    // Nettoyer favoriteRecipes
    int old_len = _favoriteRecipes.length;
    _favoriteRecipes.removeWhere((id) => !recipesDict.containsKey(id));

    if (_favoriteRecipes.length < old_len) {
      hasChanges = true;
    }

    // Nettoyer weekMeals
    for (var day in _weekMeals) {
      for (int i = 0; i < day.length; i++) {
        if (day[i].isNotEmpty && !recipesDict.containsKey(day[i])) {
          day[i] = "";
          hasChanges = true;
        }
      }
    }

    if (hasChanges) {
      updateJson();
    }
  }

  Future<void> load() async {
    await ensureFileExists();
    final file = await _localFile;
    // Read the file
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);
    _defaultPersonNumber = json['_defaultPersonNumber'] ?? 1;
    _patience = (json['_patience'] ?? _patience).toDouble();
    _favoriteRecipes =
        List<String>.from(json['_favoriteRecipes'] ?? _favoriteRecipes);
    _weekMeals = (json['_weekMeals'] as List<dynamic>?)
            ?.map((day) => List<String>.from(day as List<dynamic>))
            .toList() ??
        _weekMeals;
  }

  Future<bool> isLoaded() async {
    if (_defaultPersonNumber == 0) {
      await load();
    }
    return true;
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/personnel.json');
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
    final json = {
      '_defaultPersonNumber': _defaultPersonNumber,
      '_patience': _patience,
      '_favoriteRecipes': _favoriteRecipes,
      '_weekMeals': _weekMeals.map((day) => day).toList(),
    }; //_allergiesDict.map((key, value) => MapEntry(key, value));
    String jsonString = jsonEncode(json);
    filePath.writeAsString(jsonString);
  }

  double get patience => _patience;
  set patience(double value) {
    _patience = value;
    updateJson();
  }

  int get defaultPersonNumber => _defaultPersonNumber;
  set defaultPersonNumber(int value) {
    _defaultPersonNumber = value;
    updateJson();
  }

  List<String> get favoriteRecipes =>
      _FavoriteRecipesWrapper(_favoriteRecipes, updateJson);

  List<List<String>> get weekMeals => _WeekMealsWrapper(_weekMeals, updateJson);
}

// Wrapper class for _favoriteRecipes to intercept modifications
class _FavoriteRecipesWrapper extends ListBase<String> {
  final List<String> _innerList;
  final void Function() _onModify;

  _FavoriteRecipesWrapper(this._innerList, this._onModify);

  @override
  int get length => _innerList.length;

  @override
  set length(int newLength) {
    _innerList.length = newLength;
    _onModify();
  }

  @override
  String operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, String value) {
    _innerList[index] = value;
    _onModify();
  }

  @override
  void add(String value) {
    _innerList.add(value);
    _onModify();
  }

  @override
  void addAll(Iterable<String> values) {
    _innerList.addAll(values);
    _onModify();
  }

  @override
  bool remove(Object? value) {
    final removed = _innerList.remove(value);
    _onModify();
    return removed;
  }

  @override
  String removeAt(int index) {
    final removed = _innerList.removeAt(index);
    _onModify();
    return removed;
  }

  @override
  void clear() {
    _innerList.clear();
    _onModify();
  }
}

// Wrapper class for _weekMeals to intercept modifications
class _WeekMealsWrapper extends ListBase<List<String>> {
  final List<List<String>> _innerList;
  final void Function() _onModify;

  _WeekMealsWrapper(this._innerList, this._onModify);

  @override
  int get length => _innerList.length;

  @override
  set length(int newLength) {
    _innerList.length = newLength;
    _onModify();
  }

  @override
  List<String> operator [](int index) =>
      _FavoriteRecipesWrapper(_innerList[index], _onModify);

  @override
  void operator []=(int index, List<String> value) {
    _innerList[index] = value;
    _onModify();
  }

  @override
  void add(List<String> value) {
    _innerList.add(value);
    _onModify();
  }

  @override
  void addAll(Iterable<List<String>> values) {
    _innerList.addAll(values);
    _onModify();
  }

  @override
  bool remove(Object? value) {
    final removed = _innerList.remove(value);
    _onModify();
    return removed;
  }

  @override
  List<String> removeAt(int index) {
    final removed = _innerList.removeAt(index);
    _onModify();
    return removed;
  }

  @override
  void clear() {
    _innerList.clear();
    _onModify();
  }
}
