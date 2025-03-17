import 'package:evox/models/inventory.dart';
import 'package:evox/services/database_service.dart';
import 'package:evox/services/ingredient_service.dart';

class InventoryService {
  // List<Ingridient, Int>? inventoryStatus = null; TODO: Add caching system for inventory
  final DatabaseService _databaseService = DatabaseService.instance;
  final IngredientService ingredientService = IngredientService();

  Future<List<Inventory>> listInventory() async {
    final database = await _databaseService.db;
    final List<Map<String, Object?>> inventoryMap = await database.query(
      'Inventory',
    );

    return [
      for (final map in inventoryMap)
        Inventory(
          id: map['id'] as int,
          ingredient: await ingredientService.getOne(
            map['ingredient_id'] as int,
          ),
          quantity: map['quantity'] as int,
        ),
    ];
  }

  Future<void> updateQuantity(Inventory inventory, quantity) async {
    final database = await _databaseService.db;
    if (quantity < 0 || quantity > 1000000) {
      throw Exception('Quantity limit reached!');
    }
    await database.update(
      'Inventory',
      inventory.toMap(quantity),
      where: 'id = ?',
      whereArgs: [inventory.id],
    );
  }

  Future<int> createInventoryListing(int ingredientId, int quantity) async {
    final database = await _databaseService.db;
    if (quantity < 0 || quantity > 1000000) {
      throw Exception('Quantity limit reached!');
    }
    int id = await database.insert('Inventory', {
      'ingredient_id': ingredientId,
      'quantity': quantity,
    });
    return id;
  }
}
