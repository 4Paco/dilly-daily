import 'dart:io';

import 'package:dilly_daily/data/personalisation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dilly_daily/pages/Explore/explore_page.dart';
import 'package:dilly_daily/data/recipes.dart';


import 'package:flutter/services.dart';

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


  setUp(() {

    // Add our test recipe so ExplorePage sees it immediately
    recipesDict.addRecipe(
      "pasta_test",
      "Test Recipe",
      summary: "Classic Italian pasta",
      ingredients: {"Pasta": 1, "Egg": 2, "Bacon": 3},
      steps: [],
    );

  });

  testWidgets('tap Pasta Carbonara -> add/remove', (tester) async {
    // Pump ExplorePage directly (no TestExplorePage needed)
    await tester.pumpWidget(MaterialApp(home: ExplorePage()));

    // Let widget tree build and any FutureBuilder finish
    await tester.pumpAndSettle();

    // RecipePreview should now exist
    final recipeFinder = find.text('Pasta Carbonara');
    expect(recipeFinder, findsOneWidget);

    await tester.ensureVisible(recipeFinder);
    await tester.pumpAndSettle();

    // Tap it to open RecipeDialogBox
    await tester.tap(recipeFinder);
    await tester.pumpAndSettle();

// Find the "Add" button inside the dialog (it's a TextButton)
    final addButton = find.widgetWithText(TextButton, 'Add');
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

// Verify mealPlanRecipes changed
    expect(mealPlanRecipes.containsKey('2'), isTrue);

// Now tap "Remove"
    final removeButton = find.widgetWithText(TextButton, 'Remove');
    expect(removeButton, findsOneWidget);
    await tester.tap(removeButton);
    await tester.pumpAndSettle();

    expect(mealPlanRecipes.containsKey('2'), isFalse);

  });
}

