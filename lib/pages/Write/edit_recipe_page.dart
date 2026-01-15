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

  Future<bool?> _showDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quitter sans sauvegarder ?'),
          content: const Text(
              'Toutes les modifications non sauvegardées seront perdues !'),
          actions: <Widget>[
            TextButton(
              child: const Text('Oui, annule mes changements !'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('Non, je continue d\'éditer'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme themeScheme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showDialog() ?? false;
        if (shouldPop) {
          if (mounted) {
            Navigator.pop(context, true);
          }
        }
      },
      child: Scaffold(
          body: CustomScrollView(slivers: [
        // Fixed AppBar
        SliverAppBar(
            backgroundColor: themeScheme.primary,
            foregroundColor: themeScheme.tertiaryFixed,
            pinned: true,
            centerTitle: true,
            title: Text(
              "${widget.recette.name == "" ? 'Création' : 'Édition'} de recette",
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
      ])),
    );
  }
}
