import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/models/autofill_ingredient.dart';
import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:dilly_daily/pages/Account/SpecialDiet/allergy_element.dart';
import 'package:dilly_daily/pages/Account/SpecialDiet/curated_bloc.dart';
import 'package:flutter/material.dart';

class SpecialDietPage extends StatefulWidget {
  const SpecialDietPage({
    super.key,
  });

  @override
  State<SpecialDietPage> createState() => _SpecialDietPageState();
}

class _SpecialDietPageState extends State<SpecialDietPage> {
  Future<void>? _loadAllergiesFuture; //= Future.value();
  @override
  void initState() {
    super.initState();
    _loadAllergiesFuture = allergiesList.isLoaded(); // Call load() only once
  }

  void setIntensity(String ingredient, bool value) {
    allergiesList.setIntensity(ingredient, value);
    setState(() {});
  }

  void deleteIngredient(String ingredient) {
    allergiesList.removeIngredient(ingredient);
    setState(() {});
  }

  void addIngredient(String ingredient) {
    allergiesList.addIngredient(ingredient);
    setState(() {});
  }

  void addDiet(String diet) {
    setState(() {
      for (var ingredient in ingredientsDict) {
        if (ingredientsDict.isNotDiet(diet, ingredient)) {
          addIngredient(ingredient);
        }
      }
    });
  }

  var valueKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadAllergiesFuture, // Wait for allergiesList to load
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(
                child: Text("Error loading allergies: ${snapshot.error}"));
          } else {
            // Show the actual content once loading is complete

            return Expanded(
              child: Column(children: [
                AutofillIngredient(add: (String selection) {
                  addIngredient(selection);
                  setState(() {});
                }),
                if (allergiesList.isNotEmpty) ...[
                  Column(
                    //Forbidden ingredients bloc
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocTitle(texte: "Your forbidden ingredients"),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              for (var ingredient in allergiesList)
                                AllergyElement(
                                  ingredient: ingredient,
                                  isToggled: allergiesList[ingredient]!,
                                  onToggle: (value) =>
                                      setIntensity(ingredient, value),
                                  onPressed: () => deleteIngredient(ingredient),
                                )
                            ]),
                      ),
                    ],
                  ),
                ],
                Expanded(
                  child: Column(
                    //Curated List bloc
                    children: [
                      BlocTitle(texte: "Curated Lists"),
                      Expanded(
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 1, // Adjust to control item size
                          children: [
                            CuratedBloc(
                                texte: "vegetarian", onAddDiet: addDiet),
                            CuratedBloc(texte: "hallal", onAddDiet: addDiet),
                            CuratedBloc(
                                texte: "glutenfree", onAddDiet: addDiet),
                            CuratedBloc(texte: "vegan", onAddDiet: addDiet),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            );
          }
        });
  }
}
