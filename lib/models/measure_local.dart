class MeasureLocal {
  int id;
  String name;
  MeasureLocal({required this.id, required this.name});

  MeasureLocal.fromRow(Map<String, Object?> map)
    : name = map['name'] as String,
      id = map['id'] as int;

  @override
  String toString() {
    return 'MeasureLocal{id: $id, name: $name}';
  }
}
