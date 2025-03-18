import 'package:evox/models/measure_local.dart';
import 'package:evox/services/database_service.dart';

class MeasureService {
  final DatabaseService _databaseService = DatabaseService.instance;
  final String tableName = 'Measurement';

  Future<MeasureLocal> getMeasureFromId(int id) async {
    final database = await DatabaseService.instance.db;
    final results = await database.query(
      'Measurement',
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) {
      throw Exception('Not found');
    } else {
      return MeasureLocal.fromRow(results.first);
    }
  }

  Future<List<MeasureLocal>> getAll() async {
    final database = await _databaseService.db;
    final List<Map<String, Object?>> measures = await database.query(tableName);

    return [
      for (final map in measures)
        MeasureLocal(id: map['id'] as int, name: map['name'] as String),
    ];
  }
}
