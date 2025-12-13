import 'package:dilly_daily/data/personalisation.dart';
import 'package:dilly_daily/data/recipes.dart';
import 'package:dilly_daily/models/ui/bloc_title.dart';
import 'package:dilly_daily/models/ui/custom_sliver_app_bar.dart';
import 'package:dilly_daily/pages/MealPlan/Calendar/calendar.dart';
import 'package:dilly_daily/pages/MealPlan/Calendar/calendar_dialog_box.dart';
import 'package:dilly_daily/pages/MealPlan/meal_plan_carousel.dart';
import 'package:flutter/material.dart';

class MealPlanPage extends StatefulWidget {
  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  Future<void>? _loadMealPlanFuture; //= Future.value();
  @override
  void initState() {
    super.initState();
    _loadMealPlanFuture = mealPlanRecipes.isLoaded(); // Call load() only once
  }

  void mealAddedToWeek(String recipeKey, int day, int time) {
    setState(() {
      weekMeals[day][time] = recipeKey;
    });
  }

  void toggleFavorite(String recipeKey) {
    setState(() {
      if (favoriteRecipes.contains(recipeKey)) {
        favoriteRecipes.remove(recipeKey);
      } else {
        favoriteRecipes.add(recipeKey);
      }
    });
  }

  void toggleMealPlan(String recipeKey) {
    setState(() {
      if (mealPlanRecipes.containsKey(recipeKey)) {
        mealPlanRecipes.removeRecipe(recipeKey);

        for (int day = 0; day < weekMeals.length; day++) {
          //also delete from Timeline
          if (weekMeals[day][0] == recipeKey) weekMeals[day][0] = "";
          if (weekMeals[day][1] == recipeKey) weekMeals[day][1] = "";
        }
      } else {
        mealPlanRecipes.addRecipe(recipesDict.getRecipe(recipeKey),
            recipeKey: recipeKey);
      }
    });
  }

  void toggleGroceries(String recipeKey, {int nbMeals = 0}) {
    if (nbMeals == 0) {
      nbMeals = defaultPersonNumber;
    } else {
      nbMeals = nbMeals * defaultPersonNumber;
    }
    for (String ingredient in recipesDict[recipeKey]!.ingredients.keys) {
      listeCourses.addIngredient(ingredient,
          recipesDict[recipeKey]!.ingredients[ingredient]! / 1.0 * nbMeals);
    }
  }

  void startCooking(String recipeKey, {int nbMeals = 0}) {
    if (nbMeals == 0) nbMeals = defaultPersonNumber;
  }

  void showMealPlanDialog(BuildContext context, String recipeKey) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        bool addedToGroceries = false;
        int mealsModifier = 1;
        return StatefulBuilder(
          builder: (context, setState) {
            return CalendarDialogBox(
              recipeKey: recipeKey,
              onToggleMealPlan: (recipeKey) {
                toggleMealPlan(recipeKey);
                setState(() {});
              },
              onToggleFavorite: (recipeKey) {
                toggleFavorite(recipeKey);
                setState(() {}); // Rebuild the dialog to update the icon
              },
              onToggleGroceries: (recipeKey, {int? nbMeals}) {
                toggleGroceries(recipeKey, nbMeals: nbMeals ?? 0);
                addedToGroceries = true;
                setState(() {}); // Rebuild the dialog to update the icon
              },
              onModifyMeals: (delta) {
                mealsModifier = mealsModifier + delta;
                setState(() {});
              },
              mealsModifier: mealsModifier,
              isAddedToGroceries: addedToGroceries,
              onStartCooking: (recipeKey) {
                startCooking(recipeKey);
                setState(() {}); // Rebuild the dialog to update the icon
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadMealPlanFuture, // Wait for allergiesList to load
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting
            return createMealPlanPageContent();
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(
                child: Text("Error loading recipes: ${snapshot.error}"));
          } else {
            return createMealPlanPageContent();
          }
        });
  }

  Scaffold createMealPlanPageContent() {
    bool isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Fixed AppBar
          CustomSliverAppBar(title: "Your Meal Plan"),

          // Scrollable Content
          SliverList(
            delegate: SliverChildListDelegate(
              [
                if (mealPlanRecipes.isNotEmpty) ...[
                  BlocTitle(texte: "Meal Deck"),
                  MealPlanCarousel(showMealPlanDialog: showMealPlanDialog),
                ],
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocTitle(texte: "Menu Timeline"),
                    Tooltip(
                        message: 'Drag and drop recipes to fill your Timeline!',
                        preferBelow: false,
                        //decoration: Decoration,
                        triggerMode: TooltipTriggerMode.tap,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.info_outline_rounded),
                        ))
                  ],
                ),
                Calendar(
                  onMealAddedToWeek: mealAddedToWeek,
                  showMealPlanDialog: showMealPlanDialog,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
