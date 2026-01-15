import 'dart:async';
import 'dart:core';
import 'dart:math' show max, min;

import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart' show personals;
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Recipe.dart' show Recipe;
import 'package:dilly_daily/pages/Explore/clipper.dart'
    show ConvexConcaveClipper;
import 'package:dilly_daily/pages/Explore/filter_button.dart';
import 'package:dilly_daily/pages/Explore/recipe_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:gradient_slider/gradient_slider.dart' show GradientSlider;

// ignore: must_be_immutable
class RecipesResearchBar extends StatefulWidget {
  RecipesResearchBar({
    super.key,
    required this.onEditRecipe,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
    required this.reload,
    required this.onIngredientSearch,
    required this.onPatienceSearch,
    required this.activePreferences,
    required this.activePatience,
    required this.updatePreferences,
    required this.activeSearchIngredients,
  });

  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite;
  final void Function(String) onEditRecipe;
  final void Function() reload;
  final void Function(String) onIngredientSearch;
  final void Function(double) onPatienceSearch;
  final Map<String, bool> activePreferences;
  final double activePatience;
  final void Function(Map<String, bool>) updatePreferences;
  final Set<String> activeSearchIngredients;

  @override
  State<RecipesResearchBar> createState() => _RecipesResearchBarState();
}

class _RecipesResearchBarState extends State<RecipesResearchBar> {
  var valueKey = UniqueKey();
  bool get useFoodPreferences => widget.activePreferences["food"]!;
  bool get useKitchenPreferences => widget.activePreferences["kitchen"]!;
  bool get useEnergyPreferences => widget.activePreferences["energy"]!;

  String searchOption = "name"; //ingredient, energy

  TextEditingController? _textController;

  void foodToggled() {
    widget.activePreferences["food"] = !widget.activePreferences["food"]!;
    widget.updatePreferences(widget.activePreferences);
    setState(() {});
  }

  void kitchenToggled() {
    setState(() {
      widget.activePreferences["kitchen"] =
          !widget.activePreferences["kitchen"]!;
      widget.updatePreferences(widget.activePreferences);
    });
  }

  void energyToggled() {
    setState(() {
      widget.activePreferences["energy"] = !widget.activePreferences["energy"]!;
      widget.updatePreferences(widget.activePreferences);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width <= 600;
    ColorScheme themeScheme = Theme.of(context).colorScheme;
    return Container(
      color: themeScheme.surface,
      child: Padding(
        padding: isSmallScreen
            ? EdgeInsets.fromLTRB(16, 8, 8, 8)
            : EdgeInsets.fromLTRB(500, 8, 492, 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ClipPath(
                    clipper: ConvexConcaveClipper(),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      color: themeScheme.tertiaryFixed,
                      child: searchOption == "energy"
                          ? GradientSlider(
                              thumbAsset:
                                  'assets/image/slider_thumb_cute_primary.png',
                              thumbHeight: 30,
                              thumbWidth: 30,
                              trackHeight: 20,
                              activeTrackGradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.pink]),
                              inactiveTrackGradient: LinearGradient(
                                  colors: [Colors.blue, Colors.pink]),
                              slider: Slider(
                                  value: widget.activePatience == -1
                                      ? personals.patience
                                      : widget
                                          .activePatience, // Lire directement depuis le widget
                                  onChanged: (value) {
                                    double newPatience = max(
                                        0.1,
                                        min(0.9,
                                            (value * 10).roundToDouble() / 10));
                                    widget.onPatienceSearch(
                                        newPatience); // Le parent met à jour activePatience
                                    setState(
                                        () {}); // Rebuild avec la nouvelle valeur de widget.activePatience
                                  }),
                            )
                          : Autocomplete<Map<String, String>>(
                              key: valueKey,
                              optionsBuilder: searchOption == "name"
                                  ? recipeOptionBuilding
                                  : ingOptionBuilding,
                              displayStringForOption:
                                  (Map<String, String> option) =>
                                      option['name']!,
                              onSelected: (Map<String, String> selectedOption) {
                                if (searchOption == "name") {
                                  String recipeKey = selectedOption['id']!;
                                  //reset the widget to make the typed-in content disappear
                                  widget.reload();
                                  valueKey = UniqueKey();
                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return RecipeDialogBox(
                                            recipeKey: recipeKey,
                                            onToggleMealPlan:
                                                widget.onToggleMealPlan,
                                            onToggleFavorite:
                                                widget.onToggleFavorite,
                                            onEditRecipe: widget.onEditRecipe,
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else if (searchOption == "ingredient") {
                                  String ingredient = selectedOption['id']!;

                                  //envoyer l'ingrédient au parent pour la recherche multi_ingredients
                                  widget.onIngredientSearch(ingredient);

                                  //Clear le champ de texte
                                  _textController!.clear();
                                }
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                //Sauvegarder le controller pour pouvoir le manipuler
                                _textController = textEditingController;

                                return TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                      if (searchOption == "name") {
                                        valueKey = UniqueKey();
                                        widget.reload();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder
                                          .none, // Removes the bottom line
                                      icon: Icon(
                                        searchOption == "name"
                                            ? Icons.search
                                            : Icons.add_circle_outline,
                                        color:
                                            themeScheme.onPrimaryFixedVariant,
                                      ),
                                      hintText: searchOption == "name"
                                          ? 'Rechercher des recettes...'
                                          : 'Ajouter un ingrédient...',
                                      hintStyle: TextStyle(
                                          color: themeScheme
                                              .onPrimaryFixedVariant),
                                    ) // Text style
                                    );
                              },
                            ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(-8, 0),
                  child: FilterButton(
                    themeScheme: themeScheme,
                    foodBool: useFoodPreferences,
                    onFoodToggled: foodToggled,
                    kitchenBool: useKitchenPreferences,
                    onKitchenToggled: kitchenToggled,
                    energyBool: useEnergyPreferences,
                    onEnergyToggled: energyToggled,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: isSmallScreen
                      ? const EdgeInsets.symmetric(vertical: 2, horizontal: 0)
                      : const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                  child: ChoiceChip(
                    labelPadding: EdgeInsets.zero,
                    label: Row(
                      mainAxisSize:
                          isSmallScreen ? MainAxisSize.min : MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.lunch_dining,
                          size: 15,
                        ),
                        Text(" Par Nom"),
                      ],
                    ),
                    selected: searchOption == "name",
                    showCheckmark: false,
                    onSelected: (selected) {
                      if (searchOption != "name") {
                        setState(() {
                          searchOption = "name";
                          valueKey = UniqueKey();
                          _textController?.clear();

                          widget.reload();
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: isSmallScreen
                        ? const EdgeInsets.symmetric(vertical: 2, horizontal: 2)
                        : const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                    child: ChoiceChip(
                      labelPadding: EdgeInsets.zero,
                      label: Row(
                        mainAxisSize:
                            isSmallScreen ? MainAxisSize.min : MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.science_outlined,
                            size: 15,
                          ),
                          Text(" Par Ingredient"),
                          if (widget.activeSearchIngredients.isNotEmpty) ...[
                            SizedBox(width: 4),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: themeScheme.onSecondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${widget.activeSearchIngredients.length}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: themeScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      selected: searchOption == "ingredient",
                      showCheckmark: false,
                      onSelected: (selected) {
                        if (searchOption != "ingredient") {
                          setState(() {
                            searchOption = "ingredient";
                            valueKey = UniqueKey();
                            _textController?.clear();

                            widget.reload();
                          });
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: isSmallScreen
                      ? const EdgeInsets.symmetric(vertical: 2, horizontal: 0)
                      : const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                  child: ChoiceChip(
                    labelPadding: EdgeInsets.zero,
                    label: Row(
                      mainAxisSize:
                          isSmallScreen ? MainAxisSize.min : MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.electric_bolt,
                          size: 15,
                        ),
                        Text(" Par Energie"),
                      ],
                    ),
                    selected: searchOption == "energy",
                    showCheckmark: false,
                    onSelected: (selected) {
                      if (searchOption != "energy") {
                        setState(() {
                          searchOption = "energy";
                          valueKey = UniqueKey();
                          _textController?.clear();

                          widget.reload();
                        });
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  FutureOr<Iterable<Map<String, String>>> ingOptionBuilding(
    TextEditingValue textEditingValue,
  ) {
    if (textEditingValue.text == '') {
      return const Iterable<Map<String, String>>.empty();
    }
    return ingredientsDict.where((option) {
      final String ingredient = option as String;
      final query = textEditingValue.text.toLowerCase();
      final words = ingredient.toLowerCase().split(' ');
      return words.any((word) => word.startsWith(query));
    }).map((option) => {'id': option as String, 'name': option});
  }

  FutureOr<Iterable<Map<String, String>>> recipeOptionBuilding(
    TextEditingValue textEditingValue,
  ) {
    if (textEditingValue.text == '') {
      return const Iterable<Map<String, String>>.empty();
    }

    return recipesDict.entries.where((entry) {
      Recipe recette = entry.value;
      String option = recette.name;
      final query = textEditingValue.text.toLowerCase();
      final words = option.toLowerCase().split(' ');
      return words.any((word) => word.startsWith(query));
    }).map((entry) => {'id': entry.key, 'name': entry.value.name});
  }
}
