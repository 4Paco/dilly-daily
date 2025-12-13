import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:dilly_daily/models/ui/custom_sliver_app_bar.dart';
import 'package:dilly_daily/pages/Explore/favorite_carousel.dart';
import 'package:dilly_daily/pages/Explore/recipe_preview.dart';
import 'package:flutter/material.dart';

List<String> generateSuggestions() {
  return recipesDict.toList();
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
    _loadGroceriesFuture = ingredientsDict.isLoaded(); // Call load() only once
  }

  void toggleFavorite(String recipeKey) {
    setState(() {
      if (favoriteRecipes.contains(recipeKey)) {
        favoriteRecipes.remove(recipeKey);
      } else {
        favoriteRecipes.add(recipeKey);
      }
    });
  }

  void toggleMealPlan(String recipeKey) {
    setState(() {
      if (mealPlanRecipes.containsKey(recipeKey)) {
        print(
            "mealPlan contains recipeKey $recipeKey : removing recipe from mealPlan");
        mealPlanRecipes.removeRecipe(recipeKey);
      } else {
        print(
            "mealPlan does not contain recipeKey $recipeKey : adding recipe to mealPlan");
        mealPlanRecipes.addRecipe(recipesDict.getRecipe(recipeKey),
            recipeKey: recipeKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
        future: _loadGroceriesFuture, // Wait for allergiesList to load
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(
                child: Text(
              "Error: ${snapshot.error}\n${snapshot.stackTrace}",
            ));
          } else {
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  // Fixed AppBar
                  CustomSliverAppBar(title: "Explore"),

                  PinnedHeaderSliver(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: themeScheme.tertiaryFixed,
                        borderRadius:
                            BorderRadius.circular(25), // Rounded corners
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
                              border:
                                  InputBorder.none, // Removes the bottom line
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
                        if (favoriteRecipes.isNotEmpty) ...[
                          BlocTitle(texte: "Favoris"),
                          FavoriteCarousel(
                            onToggleMealPlan: toggleMealPlan,
                            onToggleFavorite: toggleFavorite,
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
        });
  }
}
