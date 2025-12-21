import 'dart:async';
import 'dart:core'
    show Function, Iterable, Map, Set, String, bool, override, print;

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
  });

  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite;
  final void Function(String) onEditRecipe;
  final void Function() reload;

  @override
  State<RecipesResearchBar> createState() => _RecipesResearchBarState();
}

class _RecipesResearchBarState extends State<RecipesResearchBar> {
  var valueKey = UniqueKey();

  bool useFoodPreferences = true;

  bool useKitchenPreferences = true;

  void foodToggled() {
    useFoodPreferences = !useFoodPreferences;
    setState(() {});
  }

  void kitchenToggled() {
    setState(() {
      useKitchenPreferences = !useKitchenPreferences;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme themeScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: ClipPath(
              clipper: ConvexConcaveClipper(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: themeScheme.tertiaryFixed,
                child: Autocomplete<Map<String, String>>(
                  key: valueKey,
                  optionsBuilder: optionBuilding,
                  displayStringForOption: (Map<String, String> option) =>
                      option['name']!,
                  onSelected: (Map<String, String> selectedOption) {
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
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onTapOutside: (event) => {
                        FocusScope.of(context).unfocus(),
                        valueKey = UniqueKey(),
                        widget.reload(),
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none, // Removes the bottom line
                        icon: Icon(Icons.search,
                            color: themeScheme.onPrimaryFixedVariant),
                        hintText: 'Search ideas...',
                        hintStyle:
                            TextStyle(color: themeScheme.onPrimaryFixedVariant),
                        // Placeholder style
                      ), // Text style
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
    );
  }

  FutureOr<Iterable<Map<String, String>>> optionBuilding(
      TextEditingValue textEditingValue) {
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
