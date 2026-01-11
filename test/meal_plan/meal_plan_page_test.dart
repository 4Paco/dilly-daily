import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/pages/MealPlan/mealplan_page.dart';
import 'package:dilly_daily/models/Step.dart' as RecipeStep;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel =
  MethodChannel('plugins.flutter.io/path_provider');

  // Mock path_provider
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      final dir = Directory('/mock/documents/directory');
      if (!await dir.exists()) {
        await dir.create(recursive: true); // create folder for tests
      }
      return dir.path;
    }
    return null;
  });

  setUp(() async {
    // Clear previous data
    // Add a dummy recipe to recipesDict

    recipesDict.addRecipe(
      "test_recipe",
      "Test Recipe",
      ingredients: {"Tomato": 2, "Cheese": 1},
      steps: [
        RecipeStep.Step(description: "Chop tomatoes, onion, and garlic.", duration: Duration(), type: RecipeStep.StepType.preparation),
      ],
      summary: "A dummy recipe for testing",
      dishTypes: ["Meal"]
    );

    mealPlanRecipes.addRecipe(recipesDict.getRecipe("test_recipe"), recipeKey: "test_recipe");
  });

  testWidgets('Add recipe to meal plan from MealPlanPage', (tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: MealPlanPage(),
      ),
    );

    // Wait for FutureBuilders and the page to render
    await tester.pumpAndSettle();

    // Tap on the Calendar or MealPlanCarousel to open dialog
    // Here we assume Calendar or Carousel renders a Text widget with recipe name
    final recipeFinder = find.text('Test Recipe');
    expect(recipeFinder, findsOneWidget);

    // Tap the recipe to open the dialog
    await tester.tap(recipeFinder);
    await tester.pumpAndSettle();

    // In the dialog, find the "Add" button (TextButton with text 'Add')
    final cookButtonFinder = find.widgetWithText(FilledButton, "Let's cook!");
    expect(cookButtonFinder, findsOneWidget);

    await tester.tap(cookButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);

    // Verify that the step description is shown
    expect(find.text('Chop tomatoes, onion, and garlic.'), findsOneWidget);

    // Verify that the navigation shows the total steps
    expect(find.text('1 / 1'), findsOneWidget);
  });
}
