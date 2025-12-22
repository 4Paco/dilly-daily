import 'dart:async';
import 'dart:core';

import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Recipe.dart' show Recipe;
import 'package:dilly_daily/pages/Explore/clipper.dart'
    show ConvexConcaveClipper;
import 'package:dilly_daily/pages/Explore/recipe_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

// ignore: must_be_immutable
class RecipesResearchBar extends StatefulWidget {
  RecipesResearchBar({
    super.key,
    required this.onEditRecipe,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
    required this.reload,
    required this.onIngredientSearch,
    required this.activePreferences,
    required this.updatePreferences,
    required this.activeSearchIngredients,
  });

  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite;
  final void Function(String) onEditRecipe;
  final void Function() reload;
  final void Function(String) onIngredientSearch;
  final Map<String, bool> activePreferences;
  final void Function(Map<String, bool>) updatePreferences;
  final Set<String> activeSearchIngredients;

  @override
  State<RecipesResearchBar> createState() => _RecipesResearchBarState();
}

class _RecipesResearchBarState extends State<RecipesResearchBar> {
  var valueKey = UniqueKey();
  bool get useFoodPreferences => widget.activePreferences["food"]!;
  bool get useKitchenPreferences => widget.activePreferences["kitchen"]!;
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

  @override
  Widget build(BuildContext context) {
    ColorScheme themeScheme = Theme.of(context).colorScheme;
    return Container(
      color: themeScheme.surface,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
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
                      child: Autocomplete<Map<String, String>>(
                        key: valueKey,
                        optionsBuilder: searchOption == "name"
                            ? recipeOptionBuilding
                            : ingOptionBuilding,
                        displayStringForOption: (Map<String, String> option) =>
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
                                      onToggleMealPlan: widget.onToggleMealPlan,
                                      onToggleFavorite: widget.onToggleFavorite,
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
                                border:
                                    InputBorder.none, // Removes the bottom line
                                icon: Icon(
                                  searchOption == "name"
                                      ? Icons.search
                                      : Icons.add_circle_outline,
                                  color: themeScheme.onPrimaryFixedVariant,
                                ),
                                hintText: searchOption == "name"
                                    ? 'Search recipes...'
                                    : 'Add ingredient to search...',
                                hintStyle: TextStyle(
                                    color: themeScheme.onPrimaryFixedVariant),
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
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ChoiceChip(
                  labelPadding: EdgeInsets.zero,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lunch_dining,
                        size: 15,
                      ),
                      Text(" By Name"),
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
                ChoiceChip(
                  labelPadding: EdgeInsets.zero,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.science_outlined,
                        size: 15,
                      ),
                      Text(" By Ingredient"),
                      if (widget.activeSearchIngredients.isNotEmpty) ...[
                        SizedBox(width: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                    //setState(() {
                    //  if (selected) {
                    //    searchOption = "ingredient";
                    //  } else {
                    //    searchOption = "name";
                    //  }
                    //});
                    if (selected && searchOption != "ingredient") {
                      setState(() {
                        searchOption = "ingredient";
                        _textController?.clear();
                      });
                    }
                  },
                ),
                ChoiceChip(
                  labelPadding: EdgeInsets.zero,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.electric_bolt,
                        size: 15,
                      ),
                      Text(" By Energy"),
                    ],
                  ),
                  selected: searchOption == "energy",
                  showCheckmark: false,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        searchOption = "energy";
                      } else {
                        searchOption = "name";
                      }
                    });
                    //if (selected && searchOption != "energy") {
                    //  setState(() {
                    //    searchOption = "energy";
                    //    valueKey = UniqueKey();
                    //    _textController?.clear();
                    //    widget.reload();
                    //  });
                    //}
                  },
                )
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

class FilterButton extends StatelessWidget {
  FilterButton({
    super.key,
    required this.themeScheme,
    required this.foodBool,
    required this.onFoodToggled,
    required this.kitchenBool,
    required this.onKitchenToggled,
  });

  final ColorScheme themeScheme;
  bool foodBool;
  final void Function() onFoodToggled;
  bool kitchenBool;
  final void Function() onKitchenToggled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 63,
      decoration: BoxDecoration(
        color: themeScheme.tertiaryFixed,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: themeScheme.tertiaryFixed.withAlpha(80),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
          onPressed: () {
            showPopover(
              context: context,
              bodyBuilder: (context) => FilteringContent(
                useFoodPreferences: foodBool,
                onFoodToggled: onFoodToggled,
                useKitchenPreferences: kitchenBool,
                onKitchenToggled: onKitchenToggled,
              ),
              direction: PopoverDirection.bottom,
              backgroundColor: themeScheme.tertiaryFixed,
              barrierColor: Colors.transparent,
              shadow: [
                BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 10,
                    offset: Offset(-2, -1))
              ],
              width: 200,
              arrowHeight: 17,
              arrowWidth: 12,
              arrowDxOffset: 24,
              arrowDyOffset: 2,
              contentDyOffset: -12,
            );
          },
          icon: Icon(Icons.tune_rounded)),
    );
  }
}

class FilteringContent extends StatefulWidget {
  FilteringContent({
    super.key,
    required this.useFoodPreferences,
    required this.onFoodToggled,
    required this.useKitchenPreferences,
    required this.onKitchenToggled,
  });

  bool useFoodPreferences;
  final void Function() onFoodToggled;
  bool useKitchenPreferences;
  final void Function() onKitchenToggled;

  @override
  State<FilteringContent> createState() => _FilteringContentState();
}

class _FilteringContentState extends State<FilteringContent> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 200),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              title: Text("Use your food preferences"),
              trailing: Switch(
                activeTrackColor: Colors.lightGreen,
                inactiveTrackColor: Colors.deepOrange,
                thumbColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  return Colors.white;
                }),
                trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return const Color.fromARGB(
                      20, 0, 0, 0); // Consistent outline color.
                }),
                value: widget.useFoodPreferences,
                onChanged: (value) {
                  widget.onFoodToggled();
                  widget.useFoodPreferences = !widget.useFoodPreferences;
                  setState(() {});
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              title: Text("Use your kitchen preferences"),
              trailing: Switch(
                activeTrackColor: Colors.lightGreen,
                inactiveTrackColor: Colors.deepOrange,
                thumbColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  return Colors.white;
                }),
                trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return const Color.fromARGB(
                      20, 0, 0, 0); // Consistent outline color.
                }),
                value: widget.useKitchenPreferences,
                onChanged: (value) {
                  widget.onKitchenToggled();
                  widget.useKitchenPreferences = !widget.useKitchenPreferences;
                  setState(() {});
                },
              ),
            )
          ],
        ));
  }
}
