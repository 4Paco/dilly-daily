import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Recipe.dart' show Recipe;
import 'package:dilly_daily/models/UserProfile.dart';
import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:dilly_daily/models/ui/custom_sliver_app_bar.dart';
import 'package:dilly_daily/pages/Explore/favorite_carousel.dart';
import 'package:dilly_daily/pages/Explore/recipe_preview.dart';
import 'package:dilly_daily/pages/Explore/recipes_research_bar.dart';
import 'package:dilly_daily/pages/Write/edit_recipe_page.dart';
import 'package:flutter/material.dart';

List<String> generateSuggestions(Map<String, bool> activePreferences) {
  Iterable<MapEntry<String, Recipe>> recettesAcceptees =
      recettesFiltrees(activePreferences);
  return recettesAcceptees.map((entry) => entry.key).toList().take(24).toList();
}

Iterable<MapEntry<String, Recipe>> recettesFiltrees(
    Map<String, bool> activePreferences) {
  return recipesDict.entries.where((entry) {
    Recipe recette = entry.value;

    bool satisfyFoodPreferences = true;
    if (activePreferences["food"]!) {
      // La recette ne doit contenir AUCUN ingrédient mal aimé
      satisfyFoodPreferences = !allergiesList.keys
          .any((ingredient) => recette.ingredients.containsKey(ingredient));
      if (!satisfyFoodPreferences) return false; //on arrête les frais
    }

    bool satisfyGearPreferences = true;
    if (activePreferences["kitchen"]!) {
      // La recette ne doit demander AUCUN kitchen gear non possédé par l'utilisateur
      satisfyGearPreferences = recette.necessaryGear
          .every((gear) => personals.kitchenGear.contains(gear));
      if (!satisfyGearPreferences) return false;
    }

    bool satisfyEnergyPreferences = true;
    if (activePreferences["energy"]!) {
      // La recette ne doit pas être trop longue à préparer
      satisfyEnergyPreferences =
          recette.prepDuration() <= personals.patienceMinutes;
    }

    return satisfyEnergyPreferences &&
        satisfyFoodPreferences &&
        satisfyGearPreferences;
  });
}

class ExplorePage extends StatefulWidget {
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  Future<void>? _loadGroceriesFuture; //= Future.value();

  // État de recherche
  Set<String> activeSearchIngredients = {};
  double activePatience = -1;
  Map<String, bool> activePreferences = {
    "food": true,
    "kitchen": true,
    "energy": true
  };
  List<String>? searchResults;

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
      if (listeCourses.contains(ingredient) || listeCourses.appearsInList(ingredient)) {
        listeCourses.forceRemoveIngredient(ingredient);
      }
    }
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

  //Gérer la modification des filtres de recherches
  void handleFilterChange(Map<String, bool> newFilters) {
    newFilters.entries
        .map((entry) => activePreferences[entry.key] = entry.value);
    if (activePatience > 0) {
      // a 'Patience search' is ongoing
      searchResults = _filterRecipesByPatience(activePatience);
    }
    if (activeSearchIngredients.isNotEmpty) {
      // an ingredient search is ongoing
      searchResults = _filterRecipesByIngredients(activeSearchIngredients);
    }
    setState(() {});
  }

  // Gérer l'ajout d'ingrédients pour la recherche multi-ingrédients
  void handleIngredientSearch(String ingredient) {
    setState(() {
      if (activeSearchIngredients.contains(ingredient)) {
        // Si l'ingrédient est déjà dans la recherche, on le retire
        activeSearchIngredients.remove(ingredient);
      } else {
        // Sinon on l'ajoute
        activeSearchIngredients.add(ingredient);
      }

      // Recalculer les résultats de recherche
      if (activeSearchIngredients.isEmpty) {
        searchResults = null;
      } else {
        searchResults = _filterRecipesByIngredients(activeSearchIngredients);
      }
    });
  }

  void handlePatienceSearch(double newPatience) {
    activePatience = newPatience;
    searchResults = _filterRecipesByPatience(activePatience);
    setState(() {});
  }

  void removeIngredient(String ingredient) {
    setState(() {
      activeSearchIngredients.remove(ingredient);
      if (activeSearchIngredients.isEmpty) {
        searchResults = null;
      } else {
        searchResults = _filterRecipesByIngredients(activeSearchIngredients);
      }
    });
  }

  // Filtrer les recettes par ingrédients (intersection)
  List<String> _filterRecipesByIngredients(Set<String> ingredients) {
    Iterable<MapEntry<String, Recipe>> recettesAcceptees =
        recettesFiltrees(activePreferences);

    return recettesAcceptees
        .where((entry) {
          Recipe recette = entry.value;
          // La recette doit contenir TOUS les ingrédients recherchés
          return ingredients.every(
              (ingredient) => recette.ingredients.containsKey(ingredient));
        })
        .map((entry) => entry.key)
        .toList();
  }

  // Filtrer les recettes par ingrédients (intersection)
  List<String> _filterRecipesByPatience(double patience) {
    //The personal value of patience needs to be ignored
    Map<String, bool> preferences = Map<String, bool>.from(activePreferences);
    preferences["energy"] = false;
    Iterable<MapEntry<String, Recipe>> recettesAcceptees =
        recettesFiltrees(preferences);

    return recettesAcceptees
        .where((entry) {
          Recipe recette = entry.value;
          Duration maxTolerated = UserProfile.getMinutesFromPatience(patience);
          // La recette doit contenir TOUS les ingrédients recherchés
          return recette.prepDuration() <= maxTolerated;
        })
        .map((entry) => entry.key)
        .toList();
  }

  // Clear toute la recherche
  void clearSearch() {
    setState(() {
      activeSearchIngredients.clear();
      activePatience = -1;
      searchResults = null;
    });
  }

  void reload() {
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
    List<String> recipesToShow =
        searchResults ?? generateSuggestions(activePreferences);
    String sectionTitle = searchResults != null
        ? "Search Results (${searchResults!.length})"
        : "Suggestions";
    final themeScheme = Theme.of(context).colorScheme;
    print(recipesToShow);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Fixed AppBar
          CustomSliverAppBar(title: "Explore"),

          PinnedHeaderSliver(
              child: RecipesResearchBar(
                  onEditRecipe: (recipeKey) {
                    editRecipe(recipeKey);
                    setState(() {});
                  },
                  onToggleFavorite: (recipeKey) {
                    toggleFavorite(recipeKey);
                    setState(() {}); // Rebuild the dialog to update the icon
                  },
                  onToggleMealPlan: (recipeKey) {
                    toggleMealPlan(recipeKey);
                    setState(() {});
                  },
                  onIngredientSearch: handleIngredientSearch,
                  onPatienceSearch: handlePatienceSearch,
                  activeSearchIngredients: activeSearchIngredients,
                  activePatience: activePatience,
                  activePreferences: activePreferences,
                  updatePreferences: handleFilterChange,
                  reload: clearSearch)),

          // Chips des ingrédients actifs
          if (activeSearchIngredients.isNotEmpty)
            SliverToBoxAdapter(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 00),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (String ingredient in activeSearchIngredients)
                      Chip(
                        label: Text(ingredient),
                        deleteIcon: Icon(Icons.close, size: 18),
                        onDeleted: () => removeIngredient(ingredient),
                        backgroundColor: themeScheme.secondaryContainer,
                        labelStyle: TextStyle(
                          color: themeScheme.onSecondaryContainer,
                        ),
                      ),
                    // Bouton pour tout effacer
                    ActionChip(
                      label: Text("Clear all"),
                      avatar: Icon(Icons.clear_all, size: 18),
                      onPressed: clearSearch,
                      backgroundColor: themeScheme.errorContainer,
                      labelStyle: TextStyle(
                        color: themeScheme.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Scrollable Content
          SliverList(
            delegate: SliverChildListDelegate(
              [
                if (personals.favoriteRecipes.isNotEmpty &&
                    searchResults == null) ...[
                  BlocTitle(texte: "Favoris"),
                  FavoriteCarousel(
                    onToggleMealPlan: toggleMealPlan,
                    onToggleFavorite: toggleFavorite,
                    onEditRecipe: editRecipe,
                  )
                ],
                // Titre de section avec animation
                BlocTitle(
                  key: ValueKey(sectionTitle),
                  texte: sectionTitle,
                ),

                //Message si aucun résultat
                if (searchResults != null && searchResults!.isEmpty) ...[
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
                          "No recipes found",
                          style: TextStyle(
                            color: themeScheme.onSurfaceVariant,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Try removing some ingredients",
                          style: TextStyle(
                            color: themeScheme.onSurfaceVariant.withAlpha(178),
                            fontSize: 14,
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
                      for (String recipeKey in recipesToShow) ...[
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
