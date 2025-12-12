import 'package:dilly_daily/data/ingredients.dart';
import 'package:dilly_daily/data/personalisation.dart';
import 'package:flutter/material.dart';

class IngredientTile extends StatelessWidget {
  const IngredientTile({
    super.key,
    required this.ingredient,
    required this.qtt,
    required this.onToggleGroceryList,
  });

  final String ingredient;
  final double qtt;
  final void Function(String, double) onToggleGroceryList;

  @override
  Widget build(BuildContext context) {
    bool isChecked = listeCourses.isIngredientChecked(ingredient);
    dynamic displayedQtt = qtt;
    String unit;

    if (ingredientsDict.contains(ingredient)) {
      unit = ingredientsDict[ingredient]!["unit"] ?? "";
    } else {
      unit = "";
    }
    String texte = "";

    if (unit.isEmpty) {
      // inverse ingredient name and qtt
      if (displayedQtt.round() == displayedQtt) {
        displayedQtt = displayedQtt.round();
      }

      if (displayedQtt > 0) {
        texte = "${displayedQtt.toString()} ";
      }
      texte += ingredient;
      if (displayedQtt > 1) {
        //add an "s" to the ingredient when there's several
        texte += "s";
      }
    } else {
      texte = ingredient;

      if (!unit.endsWith("g") && !unit.endsWith("L")) {
        unit = " $unit"; //space for readability
        if (displayedQtt > 1) {
          if (unit.endsWith("h")) {
            //pinch
            unit = "${unit}es";
          } else {
            unit = "${unit}s"; //spoon
          }
        }
      }

      if (displayedQtt > 1000) {
        if (unit.startsWith("m")) {
          unit = unit.substring(1);
          displayedQtt = displayedQtt / 1000;
        } else if ((unit == "g") || (unit == "L")) {
          unit = "k$unit";
          displayedQtt = displayedQtt / 1000;
        }
      }

      if (displayedQtt.round() == displayedQtt) {
        displayedQtt = displayedQtt.round();
      }
      if (displayedQtt > 0) {
        texte += " : ${displayedQtt.toString()}$unit";
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
            value: isChecked,
            onChanged: (value) {
              isChecked = !isChecked;
              onToggleGroceryList(ingredient, qtt);
            }),
        Text(
          texte,
          style: isChecked
              ? TextStyle(decoration: TextDecoration.lineThrough)
              : TextStyle(),
        ),
      ],
    );
  }
}
