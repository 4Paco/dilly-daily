import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:flutter/material.dart';

class RecipeDialogBox extends StatelessWidget {
  const RecipeDialogBox({
    super.key,
    required this.recipeKey,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
    required this.onEditRecipe,
  });

  final String recipeKey;
  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite;
  final void Function(String) onEditRecipe;
  final double horizontalPadding = 50.0;
  final double verticalPadding = 150;
  final double verticalOffset = 50;

  double calculateTotalPrice() {
    double total = 0.0;
    Recipe recette = recipesDict[recipeKey]!;
    recette.ingredients.forEach((ingredient, quantity) {
      double priceperunit = ingredientsDict[ingredient]?['price'] ?? 0.0;
      total += priceperunit * quantity;
    });

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    IconData icon;
    if (personals.favoriteRecipes.contains(recipeKey)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    bool isSmallScreen = MediaQuery.of(context).size.width <= 600;

    return Padding(
      padding: EdgeInsets.only(
          top: verticalPadding - verticalOffset,
          bottom: verticalPadding + verticalOffset,
          right: horizontalPadding + (isSmallScreen ? 0 : 600),
          left: horizontalPadding + (isSmallScreen ? 0 : 600)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: themeScheme.tertiaryContainer,
            border:
                BoxBorder.all(width: 2, color: Color.fromARGB(100, 0, 0, 0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CloseButton(),
                IconButton(
                    onPressed: () {
                      onEditRecipe(recipeKey);
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      onToggleFavorite(recipeKey);
                    },
                    icon: Icon(
                      icon,
                      size: 30,
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    recipesDict[recipeKey]!.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "${(recipesDict[recipeKey]?.summary ?? "No description available.")} ${calculateTotalPrice().toStringAsFixed(2)} €",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 10, bottom: 10),
                      child: TextButton(
                          style: ButtonStyle(
                              shadowColor:
                                  WidgetStateProperty.all(themeScheme.shadow),
                              elevation: WidgetStateProperty.all(2),
                              foregroundColor: WidgetStateProperty.all(
                                  themeScheme.onPrimary),
                              backgroundColor: WidgetStateProperty.all(
                                  mealPlanRecipes.containsKey(recipeKey)
                                      ? themeScheme.tertiary
                                      : themeScheme.primary)),
                          onPressed: () {
                            onToggleMealPlan(recipeKey);
                          },
                          child: mealPlanRecipes.containsKey(recipeKey)
                              ? Text("Retirer")
                              : Text("Ajouter")),
                    )),
                if (!isSmallScreen) //Close button is less relevent on phone+problematic displaying of the text 'Close', so simpler to just remove it on 'small screens'
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 10),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side:
                              BorderSide(color: themeScheme.primary, width: 2),
                          foregroundColor: themeScheme.primary,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"),
                      ),
                    ),
                  ),
                if (mealPlanRecipes.containsKey(recipeKey)) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 10),
                    child: Container(
                        decoration: BoxDecoration(
                          color: themeScheme.tertiaryFixedDim,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.check,
                              color: themeScheme.secondaryFixed),
                        )),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
