import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:dilly_daily/pages/Explore/recipe_preview.dart';
import 'package:dilly_daily/pages/Write/edit_recipe_page.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  void toggleFavorite(String recipeKey) {
    setState(() {
      if (personals.favoriteRecipes.contains(recipeKey)) {
        personals.favoriteRecipes.remove(recipeKey);
      } else {
        Recipe recette = recipesDict.getRecipe(recipeKey);
        String recetteId = recipeKey;
        String personalized = recette.personalized;

        if (personals.favoriteRecipes.contains(personalized)) {
          //if the recipe is edited and original is in MealPlan
          personals.favoriteRecipes.remove(personalized);
        } else {
          if (recette.personalized != "Nope") {
            recetteId = recette.personalized;
          }

          personals.favoriteRecipes.add(recetteId);
        }
      }
    });
  }

  void editRecipe(String recipeKey) async {
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => EditSubPage(recipe: recipesDict[recipeKey]),
      ),
    );
    setState(() {});
  }

  void toggleMealPlan(String recipeKey) {
    setState(() {
      if (mealPlanRecipes.containsKey(recipeKey)) {
        print("1");
        removeGroceries(recipeKey);
        mealPlanRecipes.removeRecipe(recipeKey);
        print("2");
        for (int day = 0; day < personals.weekMeals.length; day++) {
          //also delete from Timeline
          if (personals.weekMeals[day][0] == recipeKey) {
            personals.weekMeals[day][0] = "";
          }
          if (personals.weekMeals[day][1] == recipeKey) {
            personals.weekMeals[day][1] = "";
          }
        }
        print("3");
      } else {
        print("4");
        Recipe recette = recipesDict.getRecipe(recipeKey);
        String recetteId = recipeKey;
        String personalized = recette.personalized;

        if (mealPlanRecipes.containsKey(personalized)) {
          print("5");
          removeGroceries(personalized);
          //if the recipe is edited and original is in MealPlan
          mealPlanRecipes.removeRecipe(personalized);

          for (int day = 0; day < personals.weekMeals.length; day++) {
            //also delete from Timeline
            if (personals.weekMeals[day][0] == personalized) {
              personals.weekMeals[day][0] = "";
            }
            if (personals.weekMeals[day][1] == personalized) {
              personals.weekMeals[day][1] = "";
            }
          }
          print("6");
        } else {
          print("7");
          if (recette.personalized != "Nope") {
            print("8");
            recetteId = recette.personalized;
          }

          mealPlanRecipes.addRecipe(recette, recipeKey: recetteId);
          print("9");
        }
      }
    });
  }

  void removeGroceries(String recipeKey, {int nbMeals = 0}) {
    for (String ingredient in recipesDict[recipeKey]!.ingredients.keys) {
      if (listeCourses.contains(ingredient) ||
          listeCourses.appearsInList(ingredient)) {
        listeCourses.forceRemoveIngredient(ingredient);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Scrollable Content
          SliverList(
            delegate: SliverChildListDelegate(
              [
                //Message si aucun résultat
                if (personals.favoriteRecipes.isEmpty) ...[
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: themeScheme.onSurfaceVariant.withAlpha(127),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Aucune recette en favoris ! \n(pour l'instant)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeScheme.onSurfaceVariant,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  GridView.count(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Disable GridView scrolling
                    crossAxisCount: 2,
                    childAspectRatio: 1, // Adjust to control item size
                    children: [
                      for (String recipeKey in personals.favoriteRecipes) ...[
                        RecipePreview(
                          recipeKey: recipeKey,
                          texte: recipesDict[recipeKey]!.name,
                          img: recipesDict[recipeKey]!.image,
                          onToggleMealPlan: toggleMealPlan,
                          onToggleFavorite: toggleFavorite,
                          onEditRecipe: editRecipe,
                        )
                      ]
                    ],
                  )
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
