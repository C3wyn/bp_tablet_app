import 'dart:convert';

import 'package:bp_tablet_app/models/bpmodel.model.dart';

class BPIngredient implements BackPointModel {
  int _id = -1;
  int get ID => _id;

  late String _name;

  String get Name => _name;

  set Name(String value) {
    _name = value;
  }

  BPIngredient(
    int id,
    String name
  ){
    _id = id;
    _name = name;
  }

  String toJson(
    {
      String? newName
    }
  ) {
    return jsonEncode({
      "ID": _id,
      "Name": newName?? _name
    });
  }

  factory BPIngredient.fromJson(int id, Map<String,dynamic> json) {
    return BPIngredient(
      id,
      json['Name'] as String
    );
  }
}