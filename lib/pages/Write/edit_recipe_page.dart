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
