import 'dart:convert';

import 'package:bp_tablet_app/models/bpmodel.model.dart';

class BPIngredient implements BackPointModel {
  late String ID;

  late String _name;

  String get Name => _name;

  set Name(String value) {
    _name = value;
  }

  BPIngredient(String id, String name) {
    ID = id;
    _name = name;
  }

  factory BPIngredient.fromJson(Map<String, dynamic> json) {
    return BPIngredient(json['_id'], json['Name'] as String);
  }
}
