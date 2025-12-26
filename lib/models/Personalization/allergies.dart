import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Allergies extends Iterable implements Iterator {
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

  Iterable<String> get keys => _allergiesDict.keys;

  Future<void> load() async {
    await ensureFileExists();
    final file = await _localFile;
    // Read the file
    final jsonString = await file.readAsString();
    jsonDecode(jsonString);
    // for (String key in json.keys) {
    //   _allergiesDict[key] = json[key] as bool;
    // }
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
