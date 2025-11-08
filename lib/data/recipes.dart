import 'dart:convert';

import 'package:dilly_daily/data/personalisation.dart'
    show MyRecipes, myRecipes, Recipe;
import 'package:flutter/services.dart' show rootBundle;

Recipes recipesDict = Recipes();

List<String> personalizedVal = ["Nope", "Created", "Edited"];
List<String> dishTypesVal = [
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

class Recipes extends Iterable with Iterator {
  Map<int, Recipe> _recipesDict = {};
  MyRecipes theirRecipes = myRecipes;

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
    Recipe recipe = Recipe();
    for (String key in data.keys) {
      int id = int.parse(key);
      recipe = Recipe();
      for (String valKey in data[key].keys) {
        if (valKey == "name") {
          recipe.name = data[key][valKey];
        } else if (valKey == "image") {
          recipe.image = data[key][valKey];
        } else if (valKey == "servings") {
          recipe.servings = data[key][valKey];
        } else if (valKey == "readyInMinutes") {
          recipe.readyInMinutes = data[key][valKey];
        } else if (valKey == "cookingMinutes") {
          recipe.cookingMinutes = data[key][valKey];
        } else if (valKey == "preparationMinutes") {
          recipe.preparationMinutes = data[key][valKey];
        } else if (valKey == "personalized") {
          recipe.personalized = data[key][valKey];
        } else if (valKey == "recipeLink") {
          recipe.recipeLink = data[key][valKey];
        } else if (valKey == "steps") {
          recipe.steps = List<String>.from(data[key][valKey]);
        } else if (valKey == "ingredients") {
          recipe.ingredients = (data[key][valKey] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value as double));
        } else if (valKey == "dishTypes") {
          recipe.dishTypes = List<String>.from(data[key][valKey]);
        } else if (valKey == "summary") {
          recipe.summary = data[key][valKey];
        }
      }

      _recipesDict[id] = recipe;
    }

    for (int id in theirRecipes.toList()) {
      _recipesDict[-(id + 1)] = theirRecipes[id]!;
    }
  }

  Future<bool> isLoaded() async {
    if (_recipesDict.isEmpty) {
      await load();
    }
    return _recipesDict.isNotEmpty;
  }

  Recipe? operator [](int recipe) {
    if (_recipesDict.containsKey(recipe)) {
      return _recipesDict[recipe];
    } else {
      return null;
    }
  }

  @override
  List<int> toList({bool growable = true}) {
    return _recipesDict.keys.toList(growable: growable);
  }

  void addRecipe(String name,
      {String image = "",
      int servings = 1,
      int readyInMinutes = -1,
      int cookingMinutes = -1,
      int preparationMinutes = -1,
      String personalized = "Created",
      String recipeLink = "",
      List<String> steps = const [],
      Map<String, double> ingredients = const {},
      List<String> dishTypes = const ["Meal"],
      String summary = ""}) {
    Recipe recipe = Recipe(
        name: name,
        summary: summary,
        personalized: personalized,
        recipeLink: recipeLink,
        image: image,
        dishTypes: dishTypes,
        readyInMinutes: readyInMinutes,
        preparationMinutes: preparationMinutes,
        cookingMinutes: cookingMinutes,
        servings: servings,
        ingredients: ingredients,
        steps: steps);
    theirRecipes.addRecipe(recipe);
  }
}
