import 'package:evox/models/ingredient.dart';
import 'package:evox/services/database_service.dart';

class IngredientService {
  final DatabaseService _databaseService = DatabaseService.instance;
  final String tableName = 'Ingredient';
  Future<List<Ingredient>> getAll() async {
    final database = await _databaseService.db;
    final List<Map<String, Object?>> ingredientMap = await database.query(
      tableName,
    );

    return [
      for (final map in ingredientMap)
        Ingredient(id: map['id'] as int, name: map['name'] as String),
    ];
  }

  Future<Ingredient> getOne(id) async {
    final database = await _databaseService.db;
    final results = await database.query(
      tableName,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) {
      throw Exception('Not found');
    } else {
      return Ingredient.fromRow(results.first);
    }
  }

  Future<int> saveOne(name) async {
    final database = await _databaseService.db;
    var id = database.insert('Ingredient', {'name': name});
    return id;
  }
}
