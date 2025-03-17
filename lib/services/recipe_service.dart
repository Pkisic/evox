import 'package:evox/enums/meal_of_day.dart';
import 'package:evox/models/recipe.dart';
import 'package:evox/services/database_service.dart';

class RecipeService {
  final DatabaseService _databaseService = DatabaseService.instance;
  final tableName = 'Recipe';
  createRecipe(String name, int duration, String instructions) async {
    final db = await _databaseService.db;
    Recipe(
      name: name,
      instructions: instructions,
      mealofday: Mealofday.vecera,
      ingredients: List.empty(),
    );
  }
}
