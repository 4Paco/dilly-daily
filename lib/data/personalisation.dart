import 'package:dilly_daily/models/Personalization/allergies.dart';
import 'package:dilly_daily/models/Personalization/my_recipes.dart';
import 'package:dilly_daily/models/Personalization/personalized_groceries.dart';
import 'package:dilly_daily/models/Personalization/petites_merles.dart';
import 'package:dilly_daily/models/groceries.dart';

Allergies allergiesList = Allergies();
Groceries listeCourses = Groceries();
PersonalizedGroceries coursesPersonnelles = PersonalizedGroceries();

MyRecipes myRecipes = MyRecipes();
MyRecipes mealPlanRecipes = MyRecipes(recipeFile: "meal_plan_recipes");

PetitesMerles personals = PetitesMerles();
