import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:dilly_daily/models/recipes_dico.dart';
import 'package:dilly_daily/pages/Write/edit_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController linkController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.widget.recette.name);
    descriptionController =
        TextEditingController(text: widget.widget.recette.summary);
    linkController =
        TextEditingController(text: widget.widget.recette.recipeLink);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }
  //Recipe(
  //    {this.name = "",
  //    String? id,
  //    this.summary = "",
  //    this.steps = const [],
  //    this.ingredients = const {},
  //    this.personalized = "Nope",
  //    this.recipeLink = "",
  //    this.dishTypes = const ["Meal"],
  //    this.servings = 1,
  //    this.image = ""})
  //    : id = id ?? Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              //Name
              controller: nameController,
              //initialValue: widget.widget.recette.name,
              decoration: InputDecoration(
                  hintText: (nameController.text == "")
                      ? 'Name of the recipe'
                      : nameController.text),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              //Description
              controller: descriptionController,
              //initialValue: widget.widget.recette.name,
              decoration: const InputDecoration(hintText: 'Short description'),
            ),
            TextFormField(
              //Link
              controller: linkController,
              //initialValue: widget.widget.recette.name,
              decoration:
                  const InputDecoration(labelText: 'Website link -if relevant'),
            ),
            Wrap(
              //DishType
              children: RecipesDico.dishTypes.map((dish) {
                return ChoiceChip(
                  label: Text(dish),
                  selected: widget.widget.recette.dishTypes.contains(dish),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        widget.widget.recette.dishTypes.add(dish);
                      } else {
                        widget.widget.recette.dishTypes.remove(dish);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () async {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    widget.widget.recette.image = pickedFile.path;
                  });
                }
              },
              child: const Text('Upload Image'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (widget._formKey.currentState!.validate()) {
                    Recipe nouvelleRecette = Recipe(
                      id: widget.widget.recette.id,
                      name: nameController.text,
                      summary: descriptionController.text,
                      recipeLink: linkController.text,
                      servings: widget.widget.recette.servings,
                      dishTypes: widget.widget.recette.dishTypes,
                      personalized: widget.widget.recette.personalized,
                    );
                    myRecipes.addRecipe(nouvelleRecette);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
