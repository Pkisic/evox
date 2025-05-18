class RecipeIngredient {
  int ingredientId;
  int recepieId;
  int quantity;

  RecipeIngredient({
    required this.ingredientId,
    required this.recepieId,
    required this.quantity,
  });

  Map<String, Object?> toMap() {
    return {
      'ingredient_id': ingredientId,
      'recipe_id': recepieId,
      'quantity': quantity,
    };
  }

  RecipeIngredient.fromRow(Map<String, Object?> map)
    : ingredientId = map['ingredient_id'] as int,
      recepieId = map['recipe_id'] as int,
      quantity = map['quantity'] as int;

  @override
  String toString() {
    return 'ingredient_id: $ingredientId, recipe_id: $recepieId, quantity: $quantity';
  }
}
