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
        Ingredient(
          id: map['id'] as int,
          name: map['name'] as String,
          measureId: map['measure_id'] as int,
        ),
    ];
  }

  Future<List<Ingredient>> getIngredientsByIds(List<int> ids) async {
    final database = await _databaseService.db;
    final results = await database.query(
      tableName,
      where: 'id IN (${List.filled(ids.length, '?').join(', ')})',
      whereArgs: ids,
    );
    if (results.isEmpty) {
      throw Exception('Not found');
    } else {
      return results.map((e) => Ingredient.fromRow(e)).toList();
    }
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

  Future<int> saveOne(String name, int measureId) async {
    final database = await _databaseService.db;
    var id = database.insert('Ingredient', {
      'name': name,
      'measure_id': measureId,
    });
    return id;
  }
}
