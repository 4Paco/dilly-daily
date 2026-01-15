import 'package:dilly_daily/pages/Write/Modules/input_ingredient.dart';
import 'package:dilly_daily/pages/Write/step_editor.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_test/flutter_test.dart';
import 'package:dilly_daily/pages/Write/recipe_form.dart';
import 'package:dilly_daily/pages/Write/edit_recipe_page.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:dilly_daily/data/personalisation.dart';

void main() {
  group('RecipeForm Widget Test', () {
    late EditSubPage editSubPage;
    late GlobalKey<FormState> formKey;

    setUp(() {
      // Clear existing recipes before each test
      myRecipes.empty();

      // Create a dummy recipe
      editSubPage = EditSubPage(
        recipe: Recipe(
          id: 'test1',
          name: '',
          summary: '',
          steps: [],
          ingredients: {},
          dishTypes: [],
          necessaryGear: [],
        ),
      );

      formKey = GlobalKey<FormState>();
    });

    testWidgets('can create a recipe', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeForm(
              formKey: formKey,
              widget: editSubPage,
            ),
          ),
        ),
      );

      // --- Find the custom TextFields by order instead of hintText ---
      final textFields = find.byType(TextField);

      // Name field is the first TextField
      final nameField = find.descendant(
        of: textFields.at(0),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(nameField, 'Chocolate Cake');

      // Description field is the third TextField (after Name + Link)
      final descField = find.descendant(
        of: textFields.at(2),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(descField, 'Delicious and moist');

      // --- Expand Dish types and select first dish type ---
      final dishTypeButton = find.text('Dish type(s)');
      await tester.tap(dishTypeButton);
      await tester.pumpAndSettle();

      final firstDishChip = find.byType(ChoiceChip).first;
      await tester.tap(firstDishChip);
      await tester.pumpAndSettle();

      // --- Expand Utensils and select first utensil ---
      final utensilsButton = find.text('Necessary cookware');
      await tester.tap(utensilsButton);
      await tester.pumpAndSettle();

      final firstUtensilChip = find.byType(ChoiceChip).first;
      await tester.tap(firstUtensilChip);
      await tester.pumpAndSettle();

      final addIngredientButton = find.text('Add ingredient');
      await tester.tap(addIngredientButton);
      await tester.pumpAndSettle();

      final inputIngredient = find.byType(InputIngredient);
      expect(inputIngredient, findsOneWidget);

// Find the underlying EditableText
      final editable = find.descendant(
        of: inputIngredient,
        matching: find.byType(EditableText),
      );
      expect(editable, findsOneWidget);

      // Enter text directly
      await tester.enterText(editable, 'Tomato');
      await tester.pumpAndSettle();

// Find the Autocomplete widget
      final autoCompleteFinder = find.byType(Autocomplete<String>);
      expect(autoCompleteFinder, findsOneWidget);

// Call the onSelected callback manually
      final autoCompleteWidget =
          tester.widget<Autocomplete<String>>(autoCompleteFinder);
      autoCompleteWidget.onSelected!('Tomato');

// Rebuild to register the added ingredient
      await tester.pumpAndSettle();

// Verify ingredient is now in the tempIngredients or displayed widget
      expect(find.textContaining('Tomato'), findsOneWidget);

      final addStepButton = find.text('Add step');
// Ensure the widget is built and laid out
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

// Scroll it into view
      await tester.ensureVisible(addStepButton);
      await tester.pumpAndSettle();
      await tester.tap(addStepButton);
      await tester.pumpAndSettle();

      // Now inside StepEditor, find the description TextFormField
      final stepDescriptionField = find
          .descendant(
            of: find.byType(StepEditor),
            matching: find.byType(TextFormField),
          )
          .first;

      // Enter the step description
      await tester.enterText(stepDescriptionField, 'Mix ingredients');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Tap the "Save step" button
      final saveStepButton = find.descendant(
        of: find.byType(StepEditor),
        matching: find.widgetWithText(ElevatedButton, 'Save step'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.ensureVisible(saveStepButton);
      await tester.pumpAndSettle();
      await tester.tap(saveStepButton);
      await tester.pumpAndSettle();

      // Scroll to and tap the "Save recipe" button
      final saveRecipeButton =
          find.widgetWithText(ElevatedButton, 'Save recipe');
      await tester.ensureVisible(saveRecipeButton);
      await tester.tap(saveRecipeButton);
      await tester.pumpAndSettle();

      // --- Verify recipe was added to myRecipes ---
      expect(myRecipes.recipesDict.length, 1);
      final addedRecipe = myRecipes.recipesDict.values.first;
      expect(addedRecipe.name, 'Chocolate Cake');
      expect(addedRecipe.summary, 'Delicious and moist');
      expect(addedRecipe.ingredients.containsKey('Tomato'), true);
      expect(addedRecipe.steps.first.description, 'Mix ingredients');
      expect(addedRecipe.dishTypes.isNotEmpty, false);
      expect(addedRecipe.necessaryGear.isNotEmpty, false);
    });
  });
}
