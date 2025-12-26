import 'package:dilly_daily/models/Personalization/allergies.dart';
import 'package:dilly_daily/models/Personalization/my_recipes.dart';
import 'package:dilly_daily/models/UserProfile.dart';
import 'package:dilly_daily/models/groceries.dart';

Allergies allergiesList = Allergies();
Groceries listeCourses = Groceries();

MyRecipes myRecipes = MyRecipes();
MyRecipes mealPlanRecipes = MyRecipes(recipeFile: "meal_plan_recipes");

UserProfile personals = UserProfile(myRecipes: myRecipes);
