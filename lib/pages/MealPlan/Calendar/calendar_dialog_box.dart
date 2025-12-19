import 'dart:io' show File;
import 'dart:math' as math;

import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/pages/MealPlan/plus_minus_button.dart';
import 'package:flutter/material.dart';

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
  final double verticalPadding = 166.5;
  final double verticalOffset = 50;
  final bool isAddedToGroceries;
  final int mealsModifier;

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;
    int nbMeals = 1;

    //set the default number of meals to cook for the recipe
    nbMeals = personals.weekMeals.where((day) => day[0] == recipeKey).length +
        personals.weekMeals.where((day) => day[1] == recipeKey).length;
    nbMeals = math.max(1, nbMeals);

    nbMeals *= mealsModifier;

    IconData icon;
    if (personals.favoriteRecipes.contains(recipeKey)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    var imgDisplayed = recipesDict[recipeKey]!.image;
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
