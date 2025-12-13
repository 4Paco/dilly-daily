import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:dilly_daily/pages/Write/edit_recipe_page.dart';
import 'package:flutter/material.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.widget,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final EditSubPage widget;

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: myController,
            //initialValue: widget.widget.recette.name,
            decoration: const InputDecoration(hintText: 'Name of the recipe'),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (widget._formKey.currentState!.validate()) {
                  Recipe nouvelleRecette = Recipe(name: myController.text);
                  myRecipes.addRecipe(nouvelleRecette);
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
