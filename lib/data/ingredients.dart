import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_emoji/flutter_emoji.dart';

Ingredients ingredientsDict = Ingredients();

class Ingredients extends Iterable with Iterator {
  Map<String, dynamic> _dico = {};
  final List<String> ingredientCategories = [
    "Produce",
    "Dairy Products",
    "Meat&Deli",
    "Breads&Grains",
    "Breakfast",
    "Canned Goods",
    "Sauces&Condiments",
    "Snacks&Drinks",
    "Baking&Seasonings",
    "Other"
  ];

  int get limit => _dico.keys.length;
  int i = 0;
  @override
  int get current => i;
  @override
  bool moveNext() {
    i++;
    return i <= limit;
  }

  @override
  Iterator get iterator => _dico.keys.iterator;

  Ingredients() {
    _dico = {};
    load();
  }

  Future<void> load() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/ingredients.json');
    final data = jsonDecode(jsonString);
    for (String ing in data.keys) {
      Map<String, dynamic> newIng = data[ing];
      newIng['icon'] = EmojiParser().hasName(data[ing]["icon"])
          ? EmojiParser().get(data[ing]["icon"]).code
          : "";
      _dico[ing] = newIng;
    }
  }

  Future<bool> isLoaded() async {
    if (_dico.isEmpty) {
      await load();
    }
    return _dico.isNotEmpty;
  }

  Map? operator [](String ingredient) {
    return _dico[ingredient];
  }

  @override
  bool contains(Object? element) {
    return _dico.containsKey(element);
  }

  @override
  Iterable where(bool Function(dynamic element) test) {
    return _dico.keys.where(test);
  }

  bool isNotDiet(String diet, String ingredient) {
    return !_dico[ingredient]["diet"][diet];
  }
  //bool matchesCat(String ingredient, )
}

// https://emojipedia.org/smileys
