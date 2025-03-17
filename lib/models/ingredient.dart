class Ingredient {
  int id;
  String name;
  Ingredient({required this.id, required this.name});

  Ingredient.fromRow(Map<String, Object?> map)
    : name = map['name'] as String,
      id = map['id'] as int;

  @override
  String toString() {
    return 'Ingredient{id: $id, name: $name}';
  }
}
