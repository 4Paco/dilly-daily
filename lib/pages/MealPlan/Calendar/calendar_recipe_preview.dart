import 'package:flutter/material.dart';

class CalendarRecipePreview extends StatelessWidget {
  const CalendarRecipePreview({
    super.key,
    required this.recipeKey,
    required this.texte,
    required this.img,
    required this.showMealPlanDialog,
  });

  final String recipeKey;
  final void Function(BuildContext, String) showMealPlanDialog;
  final String texte;
  final String img;

  final EdgeInsetsGeometry padding = const EdgeInsets.all(4.0);

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
          padding: WidgetStateProperty.all(EdgeInsets.all(0)),
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
              padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 5),
              child: Text(
                texte,
                softWrap: true,
                style: TextStyle(
                  fontSize: 13,
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
