import 'package:dilly_daily/models/Step.dart' as CookingStep;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dilly_daily/pages/Write/write_page.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:dilly_daily/data/personalisation.dart';

void main() {
  group('WritePage Recipe Deletion Test', () {
    setUp(() {
      // Clear recipes before each test
      myRecipes.empty();

      // Add a sample recipe for testing
      myRecipes.addRecipe(
        Recipe(
          id: 'test1',
          name: 'Chocolate Cake',
          summary: 'Delicious and moist',
          steps: [CookingStep.Step()], // use your custom Step class
          ingredients: {'Tomato': 1},
          dishTypes: [],
          necessaryGear: [],
        ),
      );
    });

    testWidgets('recipe is displayed and can be deleted', (tester) async {
      // Wrap test in runAsync to safely handle async tasks in WritePage
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: WritePage(),
          ),
        );

        // Wait for WritePage to load all futures
        await tester.pumpAndSettle();

        // Find the recipe by its name
        final recipeButton = find.text('Chocolate Cake');
        expect(recipeButton, findsOneWidget);

        // Tap-and-hold (long press) to trigger delete logic
        await tester.longPress(recipeButton);
        await tester.pumpAndSettle();

        // If a confirmation dialog appears, tap "Delete"
        final confirmDelete = find.text('Delete');
        if (confirmDelete.evaluate().isNotEmpty) {
          await tester.tap(confirmDelete);
          await tester.pumpAndSettle();
        }

        // Verify the recipe has been removed
        expect(myRecipes.recipesDict.containsKey('Chocolate Cake'), isFalse);

      });
    });
  });
}