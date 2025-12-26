import 'package:dilly_daily/data/ingredients.dart';
import 'package:flutter/material.dart';

class AutofillIngredient extends StatelessWidget {
  AutofillIngredient({
    super.key,
    required this.add,
    this.onCancel, // Nouveau paramètre optionnel
  });

  final Function(String) add;
  final VoidCallback? onCancel; // Pour gérer l'annulation
  var valueKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    var themeScheme = Theme.of(context).colorScheme;
    return Container(
      //Ingredients search bar
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: themeScheme.tertiaryFixed,
        borderRadius: BorderRadius.circular(25), // Rounded corners
      ),
      child: Autocomplete<String>(
        key: valueKey,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          print(textEditingValue.text.toLowerCase());
          return ingredientsDict.where((option) {
            final String ingredient = option as String;
            final query = textEditingValue.text.toLowerCase();
            final words = ingredient.toLowerCase().split(' ');
            return words.any((word) => word.startsWith(query));
          }).cast<String>();
        },
        onSelected: (String selection) {
          valueKey =
              UniqueKey(); //reset the widget to make the typed-in content disappear
          add(selection);
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon:
                  Icon(Icons.search, color: themeScheme.onPrimaryFixedVariant),
              hintText: 'Search and Add ingredients...',
              hintStyle: TextStyle(
                  color:
                      themeScheme.onPrimaryFixedVariant), // Placeholder style
            ), // Text style
          );
        },
      ),
    );
  }
}
