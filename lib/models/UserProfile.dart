import 'dart:collection' show ListBase;
import 'dart:convert';
import 'dart:io';

import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Personalization/my_recipes.dart'
    show MyRecipes;
import 'package:path_provider/path_provider.dart';

class UserProfile {
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
  List<String> _kitchenGear = [];
  final MyRecipes _myRecipes;

  UserProfile({
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
    _kitchenGear = List<String>.from(json['_kitchenGear'] ?? []);
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
    return File('$path/user.json');
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
      '_kitchenGear': _kitchenGear,
    }; //_allergiesDict.map((key, value) => MapEntry(key, value));
    //final json = {};
    String jsonString = jsonEncode(json);
    filePath.writeAsString(jsonString);
  }

  double get patience => _patience;
  set patience(double value) {
    _patience = value;
    updateJson();
  }

  //patience range between 0.1 and 0.5
  static int minutes_01 = 5;
  static int minutes_05 = 35;
  static int minutes_08 = 60;
  Duration get patienceMinutes {
    if (_patience <= 0.5) {
      return Duration(
          minutes: (_patience * (minutes_05 - minutes_01) / 0.4 - 2.5).ceil());
    }
    if (_patience <= 0.8) {
      return Duration(
          minutes: (_patience * (minutes_08 - minutes_05) / 0.3 - 6).floor());
    }

    return Duration(days: 2); //~= +inf pour la valeur max
  }

  static Duration getMinutesFromPatience(double patience) {
    if (patience <= 0.5) {
      return Duration(
          minutes: (patience * (minutes_05 - minutes_01) / 0.4 - 2.5).ceil());
    }
    if (patience <= 0.8) {
      return Duration(
          minutes: (patience * (minutes_08 - minutes_05) / 0.3 - 6).floor());
    }

    return Duration(days: 2); //~= +inf pour la valeur max
  }

  int get defaultPersonNumber => _defaultPersonNumber;
  set defaultPersonNumber(int value) {
    _defaultPersonNumber = value;
    updateJson();
  }

  List<String> get favoriteRecipes =>
      _ShallowListWrapper(_favoriteRecipes, updateJson);

  List<String> get kitchenGear => _ShallowListWrapper(_kitchenGear, updateJson);
  set kitchenGear(List<String> newList) {
    _kitchenGear = newList;
    updateJson();
  }

  List<List<String>> get weekMeals => _DeepListWrapper(_weekMeals, updateJson);
}

// Wrapper class for _favoriteRecipes to intercept modifications
class _ShallowListWrapper extends ListBase<String> {
  final List<String> _innerList;
  final void Function() _onModify;

  _ShallowListWrapper(this._innerList, this._onModify);

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
class _DeepListWrapper extends ListBase<List<String>> {
  final List<List<String>> _innerList;
  final void Function() _onModify;

  _DeepListWrapper(this._innerList, this._onModify);

  @override
  int get length => _innerList.length;

  @override
  set length(int newLength) {
    _innerList.length = newLength;
    _onModify();
  }

  @override
  List<String> operator [](int index) =>
      _ShallowListWrapper(_innerList[index], _onModify);

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
