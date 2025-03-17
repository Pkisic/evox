import 'dart:ffi';

import 'package:evox/enums/meal_of_day.dart';
import 'package:evox/models/recipe_ingredient.dart';

class Recipe {
  String name;
  Int? duration;
  Mealofday mealofday;
  String instructions;
  List<RecipeIngredient> ingredients;

  Recipe({
    required this.name,
    required this.mealofday,
    required this.instructions,
    required this.ingredients,
  });

  getMealOfDayName() {
    return mealofday.name;
  }
}
