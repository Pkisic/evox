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

  @override
  String toString() {
    return 'ingredient_id: $ingredientId, recipe_id: $recepieId, quantity: $quantity';
  }
}
