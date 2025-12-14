import 'dart:convert';

import 'package:dilly_daily/data/personalisation.dart' show myRecipes;
import 'package:dilly_daily/models/Personalization/my_recipes.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:dilly_daily/models/Step.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class RecipesDico extends Iterable implements Iterator {
  Map<String, Recipe> _recipesDict = {};
  MyRecipes theirRecipes = myRecipes;

  bool _isLoaded = false;
  static List<String> dishTypes = [
    "main course",
    "side dish",
    "dessert",
    "appetizer",
    "salad",
    "bread",
    "breakfast",
    "soup",
    "beverage",
    "sauce",
    "marinade",
    "fingerfood",
    "snack",
    "drink"
  ];

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

  RecipesDico({bool fetch = true}) {
    _recipesDict = {};
    if (fetch) {
      load();
    }
  }

  Future<String> fetchRecipes() async {
    final response = await http
        .get(Uri.parse('https://fastapi-example-da0l.onrender.com/recipes'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> load() async {
    final String jsonString = //await fetchRecipes();
        await rootBundle.loadString('assets/data/recipes.json');
    final data = jsonDecode(jsonString);
    for (String key in data.keys) {
      String id = key;
      Recipe recipe = Recipe.fromJson(key, data[key]);
      for (String valKey in data[key].keys) {
        if (valKey == "name") {
          recipe.name = data[key][valKey];
        } else if (valKey == "image") {
          recipe.image = data[key][valKey];
        } else if (valKey == "personalized") {
          recipe.personalized = data[key][valKey];
        } else if (valKey == "steps") {
          recipe.steps = (data[key][valKey] as List)
              .map((stepJson) => Step.fromJson(stepJson))
              .toList();
        } else if (valKey == "ingredients") {
          recipe.ingredients = (data[key][valKey] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value as double));
        } else if (valKey == "summary") {
          recipe.summary = data[key][valKey];
        }
      }

      _recipesDict[id] = recipe;
    }

    for (String id in theirRecipes.toList()) {
      _recipesDict[id] = theirRecipes[id]!;
    }

    _isLoaded = true;
  }

  Future<void> isLoaded() async {
    if (!_isLoaded) {
      await load();
    }
  }

  Recipe? operator [](String recipe) {
    if (_recipesDict.containsKey(recipe)) {
      return _recipesDict[recipe];
    } else {
      return null;
    }
  }

  @override
  List<String> toList({bool growable = true}) {
    return _recipesDict.keys.toList(growable: growable);
  }

  void reloadTheirRecipes() {
    //_recipesDict.removeWhere((key, value) => key < 0);

    for (String id in theirRecipes.toList()) {
      _recipesDict[id] = theirRecipes[id]!;
    }
  }

  Recipe getRecipe(String recipeId) {
    if (_recipesDict.containsKey(recipeId)) {
      return _recipesDict[recipeId]!;
    } else {
      throw ArgumentError('No such recipe with this ID. getRecipe aborted.');
    }
  }

  void addRecipe(String recipeKey, String name,
      {String image = "",
      int servings = 1,
      int readyInMinutes = -1,
      int cookingMinutes = -1,
      int preparationMinutes = -1,
      String personalized = "Created",
      String recipeLink = "",
      List<Step> steps = const [],
      Map<String, double> ingredients = const {},
      List<String> dishTypes = const ["Meal"],
      String summary = ""}) {
    Recipe recette = Recipe(
        name: name,
        summary: summary,
        personalized: personalized,
        image: image,
        ingredients: ingredients,
        steps: steps);
    theirRecipes.addRecipe(recette, recipeKey: recipeKey);
    reloadTheirRecipes();
  }
}
