import 'dart:convert';

import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:http/http.dart' as http;

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

  Future<String> fetchIngredients() async {
    final response = await http.get(
        Uri.parse('https://fastapi-example-da0l.onrender.com/ingredients'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Attention, on a réussi à parler avec le server !");
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load ingredients');
    }
  }

  Future<void> load() async {
    final String jsonString =
        await fetchIngredients(); //comment this line when you don't want to use the server
    //await rootBundle.loadString('assets/data/ingredients.json');
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
