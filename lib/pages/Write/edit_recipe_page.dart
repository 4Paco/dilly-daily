import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/Recipe.dart';
import 'package:dilly_daily/pages/Write/recipe_form.dart';
import 'package:flutter/material.dart';

class EditSubPage extends StatefulWidget {
  EditSubPage({
    super.key,
    Recipe? recipe,
  }) : recette = recipe ?? Recipe();

  Recipe recette;

  @override
  State<EditSubPage> createState() => _EditSubPageState();
}

class _EditSubPageState extends State<EditSubPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.recette.personalized == "Nope") {
      //Dans ce cas, la recette vient d'être créée ou il faut la noter comme éditée
      if (recipesDict.databaseContains(widget.recette.id)) {
        print("vient de la database");
        //Si la recette a été envoyée depuis bigDico
        //il faut voir si la version éditée n'existe pas déjà
        List<String> listeEditions = myRecipes.values
            .where((recipe) => recipe.personalized != 'Nope')
            .map((recipe) => recipe.personalized)
            .toList();
        if (listeEditions.contains(widget.recette.id)) {
          //la version éditée existe déjà
          widget.recette = myRecipes.values
              .firstWhere((recipe) => recipe.personalized == widget.recette.id);
        } else {
          //on crée la version éditée !!
          widget.recette.personalized = widget.recette.id;
          widget.recette.id = Recipe.generateId();
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme themeScheme = Theme.of(context).colorScheme;
    return Scaffold(
        body: CustomScrollView(slivers: [
      // Fixed AppBar
      SliverAppBar(
          backgroundColor: themeScheme.primary,
          foregroundColor: themeScheme.tertiaryFixed,
          pinned: true,
          centerTitle: true,
          title: Text(
            "${widget.recette.name == "" ? 'Create' : 'Edit'} Recipe",
            style: TextStyle(fontWeight: FontWeight.w900),
          )),
      PinnedHeaderSliver(
        child: Divider(
          thickness: 5,
          color: themeScheme.tertiaryFixedDim,
          height: 5,
        ),
      ),

      // Scrollable Content
      SliverList(
          delegate: SliverChildListDelegate(
              [RecipeForm(formKey: _formKey, widget: widget)]))
    ]));
  }
}
