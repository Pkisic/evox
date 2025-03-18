class Ingredient {
  int id;
  String name;
  int measureId;
  Ingredient({required this.id, required this.name, required this.measureId});

  Ingredient.fromRow(Map<String, Object?> map)
    : name = map['name'] as String,
      id = map['id'] as int,
      measureId = map['measure_id'] as int;

  @override
  String toString() {
    return 'Ingredient{id: $id, name: $name, measure_id: $measureId}';
  }
}
