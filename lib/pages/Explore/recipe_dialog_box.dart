import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:flutter/material.dart';

class RecipeDialogBox extends StatelessWidget {
  const RecipeDialogBox({
    super.key,
    required this.recipeKey,
    required this.onToggleMealPlan,
    required this.onToggleFavorite,
  });

  final String recipeKey;
  final void Function(String) onToggleMealPlan;
  final void Function(String) onToggleFavorite;
  final double horizontalPadding = 50.0;
  final double verticalPadding = 150;
  final double verticalOffset = 50;

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    final recipe = recipesDict[recipeKey]!; // Get Recipe object
    final isFavorite = favoriteRecipes.contains(recipeKey);

    return Padding(
      padding: EdgeInsets.only(
        top: verticalPadding - verticalOffset,
        bottom: verticalPadding + verticalOffset,
        right: horizontalPadding,
        left: horizontalPadding,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: themeScheme.tertiaryContainer,
          border: Border.all(width: 2, color: Color.fromARGB(100, 0, 0, 0)),
        ),
        child: Column(
          children: [
            // Top row: Close button + Favorite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CloseButton(),
                IconButton(
                  onPressed: () => onToggleFavorite(recipeKey),
                  icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 30),
                )
              ],
            ),

            // Recipe title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    recipe.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  /// NEW LINE FOR RECIPE DURATION
                  if (recipe.duration().inMinutes > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        recipe.duration().inMinutes < 60
                            ? "${recipe.duration().inMinutes} min"
                            : "${recipe.duration().inHours}h${recipe.duration().inMinutes % 60 == 0 ? '' : '${recipe.duration().inMinutes % 60}'}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black, // ✔ duration text black
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Steps list
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView.separated(
                  itemCount: recipe.steps.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final step = recipe.steps[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(step.description),

                              /// NEW → Step type added under description
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  step.type.name[0].toUpperCase() +
                                      step.type.name.substring(1),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Duration shown right aligned
                        if (step.duration != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              step.formattedDuration(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black, // ✔ specifically BLACK
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
