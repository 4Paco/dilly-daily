import 'dart:io' show File;

import 'package:dilly_daily/pages/Explore/recipe_dialog_box.dart';
import 'package:flutter/material.dart';

class RecipePreview extends StatelessWidget {
  const RecipePreview({
    super.key,
    required this.recipeKey,
    required this.texte,
    required this.img,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
    this.padding = const EdgeInsets.all(15.0),
  });
  final String recipeKey;
  final String texte;
  final String img;

  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite; // Callback function type
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
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return RecipeDialogBox(
                    recipeKey: recipeKey,
                    onToggleMealPlan: (recipeKey) {
                      onToggleMealPlan(recipeKey);
                      setState(() {});
                    },
                    onToggleFavorite: (recipeKey) {
                      onToggleFavorite(recipeKey);
                      setState(() {}); // Rebuild the dialog to update the icon
                    },
                  );
                },
              );
            },
          );
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
