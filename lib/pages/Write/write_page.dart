import 'dart:io' show File;

import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Recipe.dart' show Recipe;
import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:dilly_daily/pages/Write/Modules/write_recipe_dialog_box.dart';
import 'package:dilly_daily/pages/Write/edit_recipe_page.dart';
import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  Future<void>? _loadRecipesFuture; //= Future.value();
  @override
  void initState() {
    super.initState();
    _loadRecipesFuture = myRecipes.isLoaded();
    _loadRecipesFuture = recipesDict.isLoaded();
    _loadRecipesFuture = personals.isLoaded(); // Call load() only once
  }

  void toggleFavorite(String recipeKey) {
    setState(() {
      String keyFavourite = recipeKey;
      //if (myRecipes.contains(recipeKey) &&
      //    myRecipes[recipeKey]?.personalized != "Nope") {
      //  keyFavourite = myRecipes[recipeKey]!.personalized;
      //}
      if (personals.favoriteRecipes.contains(keyFavourite)) {
        personals.favoriteRecipes.remove(recipeKey);
      } else {
        personals.favoriteRecipes.add(recipeKey);
      }
    });
  }

  void toggleMealPlan(String recipeKey) {
    setState(() {
      if (mealPlanRecipes.containsKey(recipeKey)) {
        removeGroceries(recipeKey);
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
          removeGroceries(personalized);

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

  void removeGroceries(String recipeKey, {int nbMeals = 0}) {
    for (String ingredient in recipesDict[recipeKey]!.ingredients.keys) {
      if (listeCourses.contains(ingredient) ||
          listeCourses.appearsInList(ingredient)) {
        listeCourses.forceRemoveIngredient(ingredient);
      }
    }
  }

  void deleteRecipe(String recipeKey) {
    setState(() {
      if (myRecipes.containsKey(recipeKey)) {
        myRecipes.removeRecipe(recipeKey);
        if (mealPlanRecipes.containsKey(recipeKey)) {
          mealPlanRecipes.removeRecipe(recipeKey);
        }
      }
    });
  }

  void editRecipe({String recipeKey = ""}) async {
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => recipeKey.isEmpty
            ? EditSubPage()
            : EditSubPage(recipe: myRecipes[recipeKey]),
      ),
    );
    setState(() {});
  }

  void showEditDialog(BuildContext context, String recipeKey) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WriteRecipeDialogBox(
              recipeKey: recipeKey,
              onToggleMealPlan: (recipeKey) {
                toggleMealPlan(recipeKey);
                setState(() {});
              },
              onToggleFavorite: (recipeKey) {
                toggleFavorite(recipeKey);
                setState(() {}); // Rebuild the dialog to update the icon
              },
              onEditRecipe: ([recipeKey]) {
                editRecipe(recipeKey: recipeKey ?? "");
                setState(() {}); // Rebuild the dialog to update the icon
              },
              onDeleteRecipe: (recipeKey) {
                deleteRecipe(recipeKey);
                setState(() {}); // Rebuild the dialog to update the icon
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadRecipesFuture, // Wait for allergiesList to load
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting
            return writePageContent(context);
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(
                child: Text("Error loading recipes: ${snapshot.error}"));
          } else {
            return writePageContent(context);
          }
        });
  }

  Scaffold writePageContent(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;
    bool isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Fixed AppBar
          SliverAppBar(
              backgroundColor: themeScheme.primary,
              foregroundColor: themeScheme.tertiaryFixed,
              pinned: true,
              centerTitle: true,
              title: Text(
                "Tes recettes",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: isSmallScreen ? null : 40),
              )),
          PinnedHeaderSliver(
            child: Divider(
              thickness: 5,
              color: themeScheme.tertiaryFixedDim,
              height: 5,
            ),
          ),

          // Scrollable Content
          SliverList(
            delegate: SliverChildListDelegate(
              [
                if (myRecipes.isNotEmpty) ...[
                  BlocTitle(texte: "Tes recettes originales"),
                  WriteCarousel(
                      showMealPlanDialog: showEditDialog, personalized: "Nope"),
                ] else
                  BlocTitle(
                      texte:
                          "Tu n'as pas encore personalisé ${isSmallScreen ? "\n" : ""}de recettes !"),
                if (myRecipes.values
                    .where((recette) => recette.personalized != "Nope")
                    .isNotEmpty) ...[
                  BlocTitle(texte: "Tes recettes éditées"),
                  WriteCarousel(
                    showMealPlanDialog: showEditDialog,
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeScheme.primary,
        foregroundColor: themeScheme.onPrimary,
        tooltip: 'Création de recette',
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => EditSubPage(),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }
}

class WriteCarousel extends StatelessWidget {
  const WriteCarousel(
      {super.key, required this.showMealPlanDialog, this.personalized = ""});
  final void Function(BuildContext, String) showMealPlanDialog;
  final String personalized;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        children: [
          ...myRecipes.keys.where(
            (recipeKey) {
              return personalized.isEmpty
                  ? myRecipes[recipeKey]?.personalized != "Nope"
                  : myRecipes[recipeKey]?.personalized == personalized;
            },
          ).map((recipeKey) => SizedBox(
                width: 150,
                child: RecipePreview(
                    recipeKey: recipeKey,
                    texte: myRecipes[recipeKey]!.name,
                    img: myRecipes[recipeKey]!.image,
                    showMealPlanDialog: showMealPlanDialog,
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 10)),
              ))
        ],
      ),
    );
  }
}

class RecipePreview extends StatelessWidget {
  const RecipePreview({
    super.key,
    required this.recipeKey,
    required this.texte,
    required this.img,
    required this.showMealPlanDialog,
    this.padding = const EdgeInsets.all(15.0),
  });
  final String recipeKey;
  final String texte;
  final String img;
  final void Function(BuildContext, String) showMealPlanDialog;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    var imgDisplayed = img;
    if (img.isEmpty) {
      imgDisplayed = "assets/image/meals/placeholder.jpg";
    }
    return Padding(
      padding: padding,
      child: FilledButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: () {
          showMealPlanDialog(context, recipeKey);
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 300, //overflowing, but no error so it works
                child: FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: img.isEmpty
                      ? Image.asset(
                          imgDisplayed //imgDisplayed, // Ensures the image covers the button
                          )
                      : Image.file(
                          File(imgDisplayed),
                          height: 200,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 40),
              child: Text(
                texte,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
