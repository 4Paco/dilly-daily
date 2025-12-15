import 'dart:io' show File;

import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/pages/Write/edit_recipe_page.dart';
import 'package:flutter/material.dart';

class WriteRecipeDialogBox extends StatelessWidget {
  WriteRecipeDialogBox({
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
  final double verticalPadding = 166.5;
  final double verticalOffset = 50;

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    IconData icon;
    if (personals.favoriteRecipes.contains(recipeKey)) {
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
                          Navigator.of(context, rootNavigator: true).pop(true);
                          onDeleteRecipe(recipeKey);

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
