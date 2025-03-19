import 'package:evox/enums/meal_of_day.dart';
import 'package:evox/models/ingredient.dart';
import 'package:evox/models/recipe.dart';
import 'package:evox/models/recipe_ingredient.dart';
import 'package:evox/services/database_service.dart';

class RecipeService {
  final DatabaseService _databaseService = DatabaseService.instance;
  final tableName = 'Recipe';

  Future<void> createRecipe(
    String name,
    int duration,
    String instructions,
    Map<Ingredient, int> ingredients, {
    Mealofday mealOfDay = Mealofday.dorucak,
  }) async {
    final db = await _databaseService.db;
    final lastId = await _getLastId() + 1;

    //create list of ingredients
    List<RecipeIngredient> recipeIngredients =
        ingredients.entries.map((e) {
          var ingredientId = e.key.id; // use ingredient id
          // use next available id
          return RecipeIngredient(
            ingredientId: ingredientId,
            recepieId: lastId,
            quantity: e.value,
          );
        }).toList();

    //create recipe model
    var recipe = Recipe(
      name: name,
      instructions: instructions,
      mealofday: mealOfDay,
      ingredients: recipeIngredients,
    );

    //insert recipies
    var newRecipeId = await db.insert(tableName, recipe.toRow());

    //check real db id with last used id // change if necessary
    if (!(newRecipeId == lastId)) {
      recipeIngredients.map((e) => e.recepieId = newRecipeId);
    }

    // insert recipe ingredient in batch
    var batch = db.batch();
    for (final e in recipeIngredients) {
      batch.insert('RecipeIngredient', e.toMap());
    }
    batch.commit();
    print(recipe);
  }

  getAll() async {
    final db = await _databaseService.db;
    final List<Map<String, Object?>> recipeMap = await db.query(tableName);

    return [for (final map in recipeMap) Recipe.fromRow(map)];
  }

  Future<int> _getLastId() async {
    final db = await _databaseService.db;
    var results = await db.query(
      tableName,
      columns: ['id'],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (results.isEmpty) {
      print('results.isEmpty');

      return 1;
    } else {
      print(
        'results.first'
        '${results.first['id']}',
      );
      return results.first['id'] as int;
    }
  }
}
