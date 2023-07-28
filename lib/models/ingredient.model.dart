import 'package:bp_tablet_app/models/bpmodel.model.dart';

class BPIngredient implements BackPointModel {
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