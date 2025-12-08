import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/pages/MealPlan/drag_drop_preview.dart';
import 'package:dilly_daily/pages/MealPlan/recipe_preview.dart';
import 'package:flutter/material.dart';

class MealPlanCarousel extends StatelessWidget {
  const MealPlanCarousel({
    super.key,
    required this.showMealPlanDialog,
  });
  final void Function(BuildContext, String) showMealPlanDialog;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        children: [
          for (String recipeKey in mealPlanRecipes) ...[
            SizedBox(
              width: 150,
              child: LongPressDraggable<String>(
                data: recipeKey,
                feedback: DragDropPreview(
                    texte: recipesDict[recipeKey]!.name,
                    img: recipesDict[recipeKey]!.image),
                child: RecipePreview(
                    recipeKey: recipeKey,
                    texte: recipesDict[recipeKey]!.name,
                    img: recipesDict[recipeKey]!.image,
                    showMealPlanDialog: showMealPlanDialog,
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 10)),
              ),
            )
          ]
        ],
      ),
    );
  }
}
