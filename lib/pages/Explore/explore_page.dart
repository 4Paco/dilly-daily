import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Recipe.dart' show Recipe;
import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:dilly_daily/models/ui/custom_sliver_app_bar.dart';
import 'package:dilly_daily/pages/Explore/favorite_carousel.dart';
import 'package:dilly_daily/pages/Explore/recipe_preview.dart';
import 'package:dilly_daily/pages/Write/edit_recipe_page.dart';
import 'package:flutter/material.dart';

List<String> generateSuggestions() {
  return recipesDict.toList().take(6).toList();
}

class ExplorePage extends StatefulWidget {
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Future<void>? _loadGroceriesFuture; //= Future.value();
  @override
  void initState() {
    super.initState();
    _loadGroceriesFuture = listeCourses.isLoaded();
    _loadGroceriesFuture = recipesDict.isLoaded();
    _loadGroceriesFuture = ingredientsDict.isLoaded();
    _loadGroceriesFuture = personals.isLoaded(); // Call load() only once
  }

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

  void toggleMealPlan(String recipeKey) {
    setState(() {
      if (mealPlanRecipes.containsKey(recipeKey)) {
        mealPlanRecipes.removeRecipe(recipeKey);

        for (int day = 0; day < personals.weekMeals.length; day++) {
          //also delete from Timeline
          if (personals.weekMeals[day][0] == recipeKey) {
            personals.weekMeals[day][0] = "";
          }
          if (personals.weekMeals[day][1] == recipeKey) {
            personals.weekMeals[day][1] = "";
          }
        }
      } else {
        Recipe recette = recipesDict.getRecipe(recipeKey);
        String recetteId = recipeKey;
        String personalized = recette.personalized;

        if (mealPlanRecipes.containsKey(personalized)) {
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
        } else {
          if (recette.personalized != "Nope") {
            recetteId = recette.personalized;
          }

          mealPlanRecipes.addRecipe(recette, recipeKey: recetteId);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadGroceriesFuture, // Wait for allergiesList to load
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting
            return explorePageContent();
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(
                child: Text(
              "Error: ${snapshot.error}\n${snapshot.stackTrace}",
            ));
          } else {
            return explorePageContent();
          }
        });
  }

  Scaffold explorePageContent() {
    final themeScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Fixed AppBar
          CustomSliverAppBar(title: "Explore"),

          PinnedHeaderSliver(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: themeScheme.tertiaryFixed,
                borderRadius: BorderRadius.circular(25), // Rounded corners
              ),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return const Iterable<String>.empty();
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none, // Removes the bottom line
                      icon: Icon(Icons.search,
                          color: themeScheme.onPrimaryFixedVariant),
                      hintText: 'Search ideas...',
                      hintStyle: TextStyle(
                          color: themeScheme
                              .onPrimaryFixedVariant), // Placeholder style
                    ), // Text style
                  );
                },
              ),
            ),
          ),

          // Scrollable Content
          SliverList(
            delegate: SliverChildListDelegate(
              [
                if (personals.favoriteRecipes.isNotEmpty) ...[
                  BlocTitle(texte: "Favoris"),
                  FavoriteCarousel(
                    onToggleMealPlan: toggleMealPlan,
                    onToggleFavorite: toggleFavorite,
                    onEditRecipe: editRecipe,
                  )
                ],
                BlocTitle(texte: "Suggestions"),
                GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // Disable GridView scrolling
                  crossAxisCount: 2,
                  childAspectRatio: 1, // Adjust to control item size
                  children: [
                    for (String recipeKey in generateSuggestions()) ...[
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
