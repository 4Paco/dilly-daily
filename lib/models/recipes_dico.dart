import 'dart:convert';

import 'package:dilly_daily/data/personalisation.dart' show myRecipes;
import 'package:dilly_daily/models/KitchenGear.dart' show Gear;
import 'package:dilly_daily/models/Personalization/my_recipes.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:dilly_daily/models/Step.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class RecipesDico extends Iterable implements Iterator {
  Map<String, Recipe> databaseDict = {};
  MyRecipes theirRecipes = myRecipes;
  Map<String, Recipe> _bigDict = {};

  Function? onMyRecipesChanged;

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
  static List<Gear> kitchenGear = [
    Gear(
      name: "Oven",
      icon: Icons.kitchen,
      description: "Modern electric oven for baking and roasting",
    ),
    Gear(
      name: "Mixer",
      icon: Icons.blender_rounded,
      description: "Kitchen mixer for smoothies and shakes",
    ),
    Gear(
      name: "Fryer",
      icon: Icons.local_fire_department,
      description: "Deep fryer for fries and snacks",
    ),
    Gear(
      name: "Microwave",
      icon: Icons.microwave_rounded,
      description: "Microwave oven for heating food",
    ),
  ];

  RecipesDico({bool fetch = true}) {
    _bigDict = {};
    if (fetch) {
      load();
    }
    theirRecipes.addListener(() {
      _bigDict = {};
      for (String id in databaseDict.keys) {
        _bigDict[id] = databaseDict[id]!;
      }
      reloadTheirRecipes();
    });
  }

  bool _isLoaded = false;

  int get limit => _bigDict.keys.length;
  int i = 0;
  @override
  int get current => i;
  @override
  bool moveNext() {
    i++;
    return i <= limit;
  }

  @override
  Iterator get iterator => _bigDict.keys.iterator;

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

      databaseDict[id] = recipe;
    }

    for (String id in databaseDict.keys) {
      _bigDict[id] = databaseDict[id]!;
    }
    await theirRecipes.isLoaded();
    reloadTheirRecipes();

    _isLoaded = true;
  }

  Future<void> isLoaded() async {
    if (!_isLoaded) {
      await load();
    }
  }

  Recipe? operator [](String recipe) {
    if (_bigDict.containsKey(recipe)) {
      return _bigDict[recipe];
    } else {
      return null;
    }
  }

  bool containsKey(String val) {
    return _bigDict.containsKey(val);
  }

  Iterable<MapEntry<String, Recipe>> get entries => _bigDict.entries;

  @override
  List<String> toList({bool growable = true}) {
    return _bigDict.keys.toList(growable: growable);
  }

  void reloadTheirRecipes() {
    //_recipesDict.removeWhere((key, value) => key < 0);
    for (String id in theirRecipes.keys) {
      _bigDict[id] = theirRecipes[id]!;
    }
    theirRecipes.values
        .where((recipe) => recipe.personalized != 'Nope')
        .forEach((recipe) {
      _bigDict[recipe.personalized] = recipe;
    });
  }

  Recipe getRecipe(String recipeId) {
    if (_bigDict.containsKey(recipeId)) {
      return _bigDict[recipeId]!;
    } else {
      throw ArgumentError('No such recipe with this ID. getRecipe aborted.');
    }
  }

  bool databaseContains(String recipeId) {
    return databaseDict.keys.contains(recipeId);
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
