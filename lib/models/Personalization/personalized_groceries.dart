class PersonalizedGroceries extends Iterable implements Iterator {
  Set<String> _groceriesList = {};
  late void Function()? onModify; // Callback to notify changes

  int get limit => _groceriesList.length;
  int i = 0;
  @override
  int get current => i;
  @override
  bool moveNext() {
    i++;
    return i <= limit;
  }

  @override
  Iterator get iterator => _groceriesList.iterator;

  @override
  bool get isNotEmpty => _groceriesList.isNotEmpty;
  @override
  bool get isEmpty => _groceriesList.isEmpty;
  @override
  bool contains(Object? element) {
    return _groceriesList.contains(element);
  }

  PersonalizedGroceries() {
    _groceriesList = {};
    //load();
  }

  void fromJson(dynamic json) {
    var workingJson = List<String>.from(json);
    if (json.isEmpty) {
      workingJson = [
        "Mozzarella",
        "Egg",
        "Chocolate",
        "Pasta",
        "Bacon",
        "Cereal",
        "Carrot",
        "Bread",
        "Milk",
        "Butter",
        "Toilet Paper",
        "Trash Bags",
        "Paper Towels",
        "Dish Soap",
      ];
    }
    for (String elmt in workingJson) {
      _groceriesList.add(elmt);
    }
  }

  List<String> toJson() {
    return _groceriesList.toList();
  }

  void addIngredient(String ingredient) {
    if (!_groceriesList.contains(ingredient)) {
      _groceriesList.add(ingredient);
      onModify?.call();
    }
    //updateJson();
  }

  void removeIngredient(String ingredient) {
    if (_groceriesList.contains(ingredient)) {
      _groceriesList.remove(ingredient);
      onModify?.call();
    }
    //updateJson();
  }

  bool isIngredientChecked(String ingredient) {
    return (!_groceriesList.contains(ingredient) &&
        _groceriesList.contains(ingredient));
  }

  Set<String> getIngredients() {
    return _groceriesList;
  }

  Set<String> getExtended() {
    return _groceriesList;
  }
}
