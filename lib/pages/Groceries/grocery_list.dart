import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:dilly_daily/models/ui/category_title_bloc.dart';
import 'package:dilly_daily/pages/Groceries/ingredient_tile.dart';
import 'package:flutter/material.dart';

class GroceryList extends SliverChildBuilderDelegate {
  GroceryList({
    required void Function(String, double) onToggleGroceryList,
  }) : super((BuildContext context, int index) {
          var ongoingList = listeCourses.getExtended();
          var items = <Widget>[];
          var others = <Widget>[];
          if (listeCourses.isEmpty) {
            items.add(BlocTitle(texte: "Liste vide pour le moment"));
            return index < items.length ? items[index] : null;
          }

          // Process additional elements that are no ingredient
          List<String> shopList = List.from(ongoingList.keys);
          for (String ingredient in shopList) {
            if (!ingredientsDict.contains(ingredient)) {
              others.add(IngredientTile(
                  ingredient: ingredient,
                  qtt: listeCourses[ingredient] ?? 0.0,
                  onToggleGroceryList: onToggleGroceryList));
              ongoingList.remove(ingredient);
            }
          }
          //print(listeCourses.extendedGroceriesDict);
          if (others.isNotEmpty) {
            others.insert(0, CategoryTitleBloc(cat: "Other"));
          }

          //Process usual elements
          for (String cat in ingredientsDict.ingredientCategories) {
            int catNb = 0;
            List<String> shopList = List.from(ongoingList
                .keys); //to avoid problems when ongoingList get ingredients removed
            for (String ingredient in shopList) {
              if (ingredientsDict[ingredient]!["category"] == cat) {
                catNb += 1;
                if (catNb == 1) items.add(CategoryTitleBloc(cat: cat));
                items.add(IngredientTile(
                    ingredient: ingredient,
                    qtt: listeCourses[ingredient] ?? 0.0,
                    onToggleGroceryList: onToggleGroceryList));
                ongoingList.remove(ingredient);
              }
            }
          }
          items = items + others;

          return index < items.length ? items[index] : null;
        });
}
