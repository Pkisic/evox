import 'package:evox/enums/meal_of_day.dart';
import 'package:evox/models/recipe_ingredient.dart';

class Recipe {
  String name;
  int? duration;
  int? id;
  Mealofday mealofday;
  String instructions;
  List<RecipeIngredient> ingredients;

  Recipe({
    required this.name,
    required this.mealofday,
    required this.instructions,
    required this.ingredients,
    this.duration,
  });

  getMealOfDayName() {
    return mealofday.name;
  }

  Map<String, Object?> toRow() {
    return {
      'name': name,
      'duration': duration,
      'meal_of_day_id': mealofday.index,
      'instructions':
          instructions, // TODO: Instructions conversion from rich text to string
    };
  }

  Recipe.fromRow(Map<String, Object?> map)
    : id = map['id'] as int,
      name = map['name'] as String,
      duration = map['duration'] as int?,
      instructions =
          map['instructions']
              as String, // TODO: Instructions conversion from rich text to string
      ingredients = List.empty(), // Ingredients List
      mealofday = Mealofday.values[map['meal_of_day_id'] as int];

  @override
  String toString() {
    return "Recipe name: $name, duration : $duration, mod: $mealofday , instructions: $instructions, ingredients: $ingredients";
  }
}
