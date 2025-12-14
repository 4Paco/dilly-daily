import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/pages/Explore/recipe_preview.dart';
import 'package:flutter/material.dart';

class FavoriteCarousel extends StatelessWidget {
  const FavoriteCarousel({
    super.key,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
    required this.onEditRecipe,
  });
  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite;
  final void Function(String) onEditRecipe; // Callback function type

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        children: [
          for (String recipeKey in favoriteRecipes) ...[
            SizedBox(
              width: 150,
              child: RecipePreview(
                  recipeKey: recipeKey,
                  texte: recipesDict[recipeKey]!.name,
                  img: recipesDict[recipeKey]!.image,
                  onToggleMealPlan: onToggleMealPlan,
                  onToggleFavorite: onToggleFavorite,
                  onEditRecipe: onEditRecipe,
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 10)),
            )
          ]
        ],
      ),
    );
  }
}
