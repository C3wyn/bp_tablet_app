class BPIngredient {
  int _id = -1;
  int get ID => _id;

  late String _name;

  String get Name => _name;

  BPIngredient(
    int id,
    String name
  ){
    _id = id;
    _name = name;
  }

  factory BPIngredient.fromJson(int id, Map<String,dynamic> json) {
    return BPIngredient(
      id,
      json['Name'] as String
    );
  }
}