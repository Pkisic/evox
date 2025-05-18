import 'package:evox/models/ingredient.dart';
import 'package:evox/models/measure_local.dart';
import 'package:evox/services/database_service.dart';
import 'package:evox/services/ingredient_service.dart';
import 'package:evox/services/measure_service.dart';

class RecipeIngredientService {
  final DatabaseService _databaseService = DatabaseService.instance;
  final String tableName = 'RecipeIngredient';

  final IngredientService _ingredientService = IngredientService();
  final MeasureService _measureService = MeasureService();

  getAllIngredientsByRecipeId(int id) async {
    final database = await _databaseService.db;
    final List<Map<String, Object?>> res = await database.query(
      tableName,
      where: 'recipe_id = ?',
      whereArgs: [id],
    );

    List<int> ingredientIds =
        res.map((e) => e['ingredient_id'] as int).toList();

    if (ingredientIds.isEmpty) return List<Map<String, dynamic>>.empty();

    List<Ingredient> ingredients = await _ingredientService.getIngredientsByIds(
      ingredientIds,
    );

    if (ingredients.isEmpty) return List<Map<String, dynamic>>.empty();

    List<int> measureIds = ingredients.map((e) => e.measureId).toList();

    if (measureIds.isEmpty) return List<Map<String, dynamic>>.empty();

    List<MeasureLocal> measures = await _measureService.getMultipleFromIds(
      measureIds,
    );

    List<Map<String, dynamic>> result =
        res.map((entry) {
          final ingredient = ingredients.firstWhere(
            (ing) => ing.id == entry['ingredient_id'],
            orElse: () => throw Exception("Ingredient not found"),
          );

          final measure = measures.firstWhere(
            (m) => m.id == ingredient.measureId,
            orElse: () => throw Exception("Measure not found"),
          );

          return {
            'ingredient': ingredient,
            'measure': measure,
            'quantity': entry['quantity'],
          };
        }).toList();

    return result;
  }
}
