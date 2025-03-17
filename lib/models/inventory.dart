import 'package:evox/models/ingredient.dart';

class Inventory {
  int id;
  Ingredient ingredient;
  int quantity;
  Inventory({
    required this.id,
    required this.ingredient,
    required this.quantity,
  });

  Map<String, Object?> toMap([updateQuantity]) {
    if (updateQuantity != null) {
      quantity = updateQuantity;
    }
    return {'id': id, 'ingredient_id': ingredient.id, 'quantity': quantity};
  }

  @override
  String toString() {
    return 'Inventory{id: $id, Ingredient: $ingredient, quantity: $quantity}';
  }
}
