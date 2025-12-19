import 'dart:async';

import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Recipe.dart' show Recipe;
import 'package:dilly_daily/pages/Explore/clipper.dart'
    show ConvexConcaveClipper;
import 'package:dilly_daily/pages/Explore/recipe_dialog_box.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RecipesResearchBar extends StatelessWidget {
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
  var valueKey = UniqueKey();

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
                    reload();
                    valueKey = UniqueKey();
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return RecipeDialogBox(
                              recipeKey: recipeKey,
                              onToggleMealPlan: onToggleMealPlan,
                              onToggleFavorite: onToggleFavorite,
                              onEditRecipe: onEditRecipe,
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
                        reload(),
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
            child: FilterButton(themeScheme: themeScheme),
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
  const FilterButton({
    super.key,
    required this.themeScheme,
  });

  final ColorScheme themeScheme;

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
      child: IconButton(onPressed: () {}, icon: Icon(Icons.tune_rounded)),
    );
  }
}
