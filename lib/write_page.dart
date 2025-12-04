import 'dart:math' as math;

import 'package:dilly_daily/account_page.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
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

  void toggleGroceries(String recipeKey, {int nbMeals = 0}) {
    if (nbMeals == 0) {
      nbMeals = defaultPersonNumber;
    } else {
      nbMeals = nbMeals * defaultPersonNumber;
    }
    for (String ingredient in recipesDict[recipeKey]!.ingredients.keys) {
      listeCourses.addIngredient(ingredient,
          recipesDict[recipeKey]!.ingredients[ingredient]! / 1.0 * nbMeals);
    }
  }

  void startCooking(String recipeKey, {int nbMeals = 0}) {
    if (nbMeals == 0) nbMeals = defaultPersonNumber;
  }

  void showMealPlanDialog(BuildContext context, String recipeKey) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        bool addedToGroceries = false;
        int mealsModifier = 1;
        return StatefulBuilder(
          builder: (context, setState) {
            return CalendarDialogBox(
              recipeKey: recipeKey,
              onToggleMealPlan: (recipeKey) {
                toggleMealPlan(recipeKey);
                setState(() {});
              },
              onToggleFavorite: (recipeKey) {
                toggleFavorite(recipeKey);
                setState(() {}); // Rebuild the dialog to update the icon
              },
              onToggleGroceries: (recipeKey, {int? nbMeals}) {
                toggleGroceries(recipeKey, nbMeals: nbMeals ?? 0);
                addedToGroceries = true;
                setState(() {}); // Rebuild the dialog to update the icon
              },
              onModifyMeals: (delta) {
                mealsModifier = mealsModifier + delta;
                setState(() {});
              },
              mealsModifier: mealsModifier,
              isAddedToGroceries: addedToGroceries,
              onStartCooking: (recipeKey) {
                startCooking(recipeKey);
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
    final themeScheme = Theme.of(context).colorScheme;

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
                if (mealPlanRecipes.isNotEmpty) ...[
                  BlocTitle(texte: "Your original recipes"),
                  WriteCarousel(showMealPlanDialog: showMealPlanDialog),
                ],
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocTitle(texte: "Your edited recipes"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeScheme.primary,
        tooltip: 'Increment',
        onPressed: () {},
        child: const Icon(Icons.add, size: 28),
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
          for (String recipeKey in mealPlanRecipes) ...[
            SizedBox(
              width: 150,
              child: RecipePreview(
                  recipeKey: recipeKey,
                  texte: recipesDict[recipeKey]!.name,
                  img: recipesDict[recipeKey]!.image,
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
                  child: Image.asset(
                    imgDisplayed, // Ensures the image covers the button
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

class CalendarDialogBox extends StatelessWidget {
  CalendarDialogBox({
    super.key,
    required this.recipeKey,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
    required this.onToggleGroceries,
    required this.onModifyMeals,
    required this.onStartCooking,
    this.isAddedToGroceries = false,
    this.mealsModifier = 0,
  });

  final String recipeKey;
  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite;
  final void Function(String, {int nbMeals}) onToggleGroceries;
  final void Function(int) onModifyMeals;
  final void Function(String) onStartCooking;
  final double horizontalPadding = 50.0;
  final double verticalPadding = 150;
  final double verticalOffset = 50;
  final bool isAddedToGroceries;
  final int mealsModifier;

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;
    int nbMeals = 1;

    //set the default number of meals to cook for the recipe
    nbMeals = weekMeals.where((day) => day[0] == recipeKey).length +
        weekMeals.where((day) => day[1] == recipeKey).length;
    nbMeals = math.max(1, nbMeals);

    nbMeals *= mealsModifier;

    IconData icon;
    if (favoriteRecipes.contains(recipeKey)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    var imgDisplayed = recipesDict[recipeKey]!.image;
    if (imgDisplayed.isEmpty) {
      imgDisplayed = "assets/image/meals/placeholder.jpg";
    }

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
                  child: FittedBox(
                    fit: BoxFit.fill,
                    clipBehavior: Clip.hardEdge,
                    child: Stack(children: [
                      Image.asset(
                        imgDisplayed, // Ensures the image covers the button
                      ),
                      Center(
                        child: Container(
                          width: 3535,
                          height: 5300,
                          color: Color.fromARGB(100, 0, 0, 0),
                        ),
                      )
                    ]),
                  ))),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CloseButton(),
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
                    recipesDict[recipeKey]!.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: themeScheme.tertiaryContainer),
                    textAlign: TextAlign.center,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: themeScheme.tertiaryFixedDim
                                      .withAlpha(200),
                                  border: BoxBorder.all(
                                      width: 2,
                                      color: Color.fromARGB(10, 0, 0, 0))),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text("$nbMeals ",
                                            textScaler: TextScaler.linear(1.4)),
                                        Text(
                                          nbMeals > 1 ? "meals" : "meal",
                                          textScaler: TextScaler.linear(1.4),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        PlusMinusButton(
                                          val: -1,
                                          icondata: Icons.remove,
                                          function: (nbMeals == 1)
                                              ? (_) {}
                                              : onModifyMeals,
                                        ),
                                        PlusMinusButton(
                                          val: 1,
                                          icondata: Icons.add,
                                          function: onModifyMeals,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  isAddedToGroceries
                                      ? null
                                      : onToggleGroceries(recipeKey,
                                          nbMeals: nbMeals);
                                },
                                style: isAddedToGroceries
                                    ? ButtonStyle(
                                        foregroundColor: WidgetStatePropertyAll(
                                            themeScheme.primary))
                                    : ButtonStyle(
                                        foregroundColor: WidgetStatePropertyAll(
                                            themeScheme.tertiaryFixedDim)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          isAddedToGroceries
                                              ? Icons.shopping_cart_outlined
                                              : Icons.shopping_cart_checkout,
                                          size: 20,
                                        ),
                                        if (isAddedToGroceries) ...[
                                          Text("x$nbMeals")
                                        ]
                                      ],
                                    ),
                                    isAddedToGroceries
                                        ? Text("Added to")
                                        : Text("Add to"),
                                    Text("groceries"),
                                  ],
                                ))
                          ]),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {},
                        onLongPress: () {
                          onToggleMealPlan(recipeKey);
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
                                      "You successfully deleted the recipe from your meal plan !",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                );
                              });
                        },
                        style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                        child: Tooltip(
                          message:
                              "Long press to remove from \nyour Deck and your Timeline",
                          triggerMode: TooltipTriggerMode.tap,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.delete_outline,
                              size: 20,
                            ),
                          ),
                        )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: TextButton(
                          style: ButtonStyle(
                              shadowColor:
                                  WidgetStateProperty.all(themeScheme.shadow),
                              elevation: WidgetStateProperty.all(2),
                              foregroundColor: WidgetStateProperty.all(
                                  themeScheme.onPrimary),
                              backgroundColor:
                                  WidgetStateProperty.all(themeScheme.primary),
                              side: WidgetStatePropertyAll(BorderSide(
                                  width: 1.5, color: themeScheme.tertiary))),
                          onPressed: () {
                            onStartCooking(recipeKey);
                          },
                          child: Text(
                            "Let's cook!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaler: TextScaler.linear(1.5),
                          )),
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
