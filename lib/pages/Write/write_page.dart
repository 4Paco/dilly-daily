import 'dart:io' show File;

import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/ui/bloc_title.dart';
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
    _loadRecipesFuture = recipesDict.isLoaded(); // Call load() only once
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
        mealPlanRecipes.removeRecipe(recipeKey);

        for (int day = 0; day < weekMeals.length; day++) {
          //also delete from Timeline
          if (weekMeals[day][0] == recipeKey) weekMeals[day][0] = "";
          if (weekMeals[day][1] == recipeKey) weekMeals[day][1] = "";
        }
      } else {
        mealPlanRecipes.addRecipe(recipesDict.getRecipe(recipeKey),
            recipeKey: recipeKey);
      }
    });
  }

  void deleteRecipe(String recipeKey) {
    setState(() {
      if (myRecipes.containsKey(recipeKey)) {
        myRecipes.removeRecipe(recipeKey);
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

  void showMealPlanDialog(BuildContext context, String recipeKey) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return OriginalRecipeDialogBox(
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
                "Your Recipes",
                style: TextStyle(fontWeight: FontWeight.w900),
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
                  BlocTitle(texte: "Your original recipes"),
                  WriteCarousel(showMealPlanDialog: showMealPlanDialog),
                ] else
                  BlocTitle(
                      texte:
                          "You haven't added any custom ${isSmallScreen ? "\n" : ""}recipe yet !"),
                //Row(
                //  mainAxisSize: MainAxisSize.min,
                //  children: [
                //    BlocTitle(texte: "Your edited recipes"),
                //  ],
                //),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeScheme.primary,
        foregroundColor: themeScheme.onPrimary,
        tooltip: 'Create new recipe',
        onPressed: () async {
          final value = await Navigator.push(
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
  const WriteCarousel({
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
          for (String recipeKey in myRecipes) ...[
            SizedBox(
              width: 150,
              child: RecipePreview(
                  recipeKey: recipeKey,
                  texte: myRecipes[recipeKey]!.name,
                  img: myRecipes[recipeKey]!.image,
                  showMealPlanDialog: showMealPlanDialog,
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 10)),
            )
          ]
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

class EmptyPreview extends StatelessWidget {
  const EmptyPreview({
    super.key,
    this.padding = const EdgeInsets.all(4.0),
  });
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: FilledButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.all(50)),
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.tertiary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: () {},
        child: Text(""),
      ),
    );
  }
}

class PlusMinusButton extends StatelessWidget {
  const PlusMinusButton({
    super.key,
    required this.function,
    required this.val,
    required this.icondata,
  });

  final void Function(int) function;
  final int val;
  final IconData icondata;

  @override
  Widget build(BuildContext context) {
    //var themeScheme = Theme.of(context).colorScheme;
    return Padding(
        padding: EdgeInsets.zero,
        child: IconButton.filled(
            padding: EdgeInsets.zero,
            //style: ButtonStyle(
            //    backgroundColor: WidgetStatePropertyAll(themeScheme.tertiary)),
            onPressed: () {
              function(val);
            },
            icon: Icon(
              icondata,
              size: 20,
            )));
  }
}

class OriginalRecipeDialogBox extends StatelessWidget {
  OriginalRecipeDialogBox({
    super.key,
    required this.recipeKey,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
    required this.onEditRecipe,
    required this.onDeleteRecipe,
  });

  final String recipeKey;
  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite;
  final void Function([String?]) onEditRecipe;
  final void Function(String) onDeleteRecipe;
  final double horizontalPadding = 50.0;
  final double verticalPadding = 166;
  final double verticalOffset = 50;

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    IconData icon;
    if (favoriteRecipes.contains(recipeKey)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    var imgDisplayed = myRecipes[recipeKey]!.image;
    //if (imgDisplayed.isEmpty) {
    //  imgDisplayed = "assets/image/meals/placeholder.jpg";
    //}

    return Padding(
      padding: EdgeInsets.only(
          top: verticalPadding - verticalOffset,
          bottom: verticalPadding + verticalOffset,
          right: horizontalPadding,
          left: horizontalPadding),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: themeScheme.tertiaryContainer,
            border:
                BoxBorder.all(width: 2, color: Color.fromARGB(200, 0, 0, 0))),
        child: Stack(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: SizedBox(
                  height: 800, //overflowing, but no error so it works
                  child: Stack(children: [
                    imgDisplayed.isEmpty
                        ? FittedBox(
                            fit: BoxFit.fill,
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                                "assets/image/meals/placeholder.jpg" //imgDisplayed, // Ensures the image covers the button
                                ),
                          )
                        : Expanded(
                            child: Image.file(
                              File(imgDisplayed),
                            ),
                          ),
                    Center(
                      child: Container(
                        width: 3535,
                        height: 5300,
                        color: Color.fromARGB(100, 0, 0, 0),
                      ),
                    )
                  ]))),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CloseButton(
                    color: themeScheme.onPrimary,
                  ),
                  IconButton(
                      onPressed: () {
                        onToggleFavorite(recipeKey);
                      },
                      icon: Icon(
                        icon,
                        size: 30,
                        color: themeScheme.tertiaryContainer,
                      ))
                ],
              ),
              Expanded(
                child: Stack(children: [
                  Text(
                    myRecipes[recipeKey]!.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: themeScheme.tertiaryContainer),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        color: themeScheme.onPrimary,
                        onPressed: () {
                          onEditRecipe(recipeKey);
                        },
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => EditSubPage(
                                recipe: myRecipes[recipeKey],
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit)),
                    TextButton(
                        onPressed: () {},
                        onLongPress: () {
                          onDeleteRecipe(recipeKey);
                          Navigator.of(context, rootNavigator: true).pop(true);
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                });
                                return AlertDialog(
                                  title: Text(
                                      "You successfully deleted the recipe !",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                );
                              });
                        },
                        child: Tooltip(
                          message:
                              "Long press to definitely delete this recipe",
                          triggerMode: TooltipTriggerMode.tap,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.delete_outline,
                              size: 20,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
