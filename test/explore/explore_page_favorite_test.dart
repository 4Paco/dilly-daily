import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/pages/Explore/recipe_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dilly_daily/pages/Explore/explore_page.dart';
import 'package:dilly_daily/data/recipes.dart';

import 'package:flutter/material.dart';
import 'package:dilly_daily/pages/Explore/explore_page.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:flutter/services.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel =
  MethodChannel('plugins.flutter.io/path_provider');

  // Mock path_provider
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      return '/mock/documents/directory';
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

  testWidgets('tap Pasta Carbonara -> toggle favorite', (tester) async {

    await tester.pumpWidget(MaterialApp(home: ExplorePage()));

    await tester.pumpAndSettle();

    // Find the recipe preview by text
    final recipeFinder = find.text('Pasta Carbonara');
    expect(recipeFinder, findsOneWidget);

    await tester.ensureVisible(recipeFinder);
    await tester.pumpAndSettle();

    // Tap it to open RecipeDialogBox
    await tester.tap(recipeFinder);
    await tester.pumpAndSettle();

    // Favorite button in the dialog is an IconButton
    final favoriteButton = find.byIcon(Icons.favorite_border);
    expect(favoriteButton, findsOneWidget);

    // Tap to favorite
    await tester.tap(favoriteButton);
    await tester.pumpAndSettle();

    // Verify it is now in favorites
    expect(personals.favoriteRecipes.contains('2'), isTrue);

    // Icon should now be filled
    final favoritedIcon = find.byIcon(Icons.favorite);
    expect(favoritedIcon, findsOneWidget);

    // Tap again to unfavorite
    await tester.tap(favoritedIcon);
    await tester.pumpAndSettle();

    // Verify it is removed from favorites
    expect(personals.favoriteRecipes.contains('2'), isFalse);
  });
}

