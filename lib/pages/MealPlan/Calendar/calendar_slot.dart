import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/pages/MealPlan/Calendar/calendar_recipe_preview.dart';
import 'package:dilly_daily/pages/MealPlan/Calendar/empty_preview.dart';
import 'package:dilly_daily/pages/MealPlan/drag_drop_preview.dart';
import 'package:flutter/material.dart';

class CalendarSlot extends StatelessWidget {
  const CalendarSlot({
    super.key,
    required this.i,
    required this.today,
    required this.time,
    required this.onMealAddedToWeek,
    required this.showMealPlanDialog,
  });

  final void Function(BuildContext, String) showMealPlanDialog;
  final int i;
  final int today;
  final int time;
  final void Function(String p1, int p2, int p3) onMealAddedToWeek;

  @override
  Widget build(BuildContext context) {
    String recipeKey = personals.weekMeals[(today + i) % 7][time];
    bool isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return DragTarget(
      builder: (context, candidateItems, rejectedItems) {
        return recipeKey.isNotEmpty
            ? LongPressDraggable(
                data: recipeKey,
                feedback: DragDropPreview(
                  texte: recipesDict[recipeKey]!.name,
                  img: recipesDict[recipeKey]!.image,
                ),
                onDraggableCanceled: (velocity, offset) {
                  onMealAddedToWeek("", (today + i) % 7, time);
                },
                child: SizedBox(
                    width: i == 0
                        ? (isSmallScreen ? 150 : 310)
                        : (isSmallScreen ? 100 : 220),
                    height: isSmallScreen ? 129 : 220,
                    child: CalendarRecipePreview(
                      recipeKey: recipeKey,
                      texte: recipesDict[recipeKey]!.name,
                      img: recipesDict[recipeKey]!.image,
                      showMealPlanDialog: showMealPlanDialog,
                    )),
              )
            : SizedBox(
                width: i == 0
                    ? (isSmallScreen ? 150 : 310)
                    : (isSmallScreen ? 100 : 220),
                height: isSmallScreen ? 129 : 220,
                child: EmptyPreview());
      },
      onAcceptWithDetails: (details) {
        onMealAddedToWeek(details.data as String, (today + i) % 7, time);
      },
    );
  }
}
