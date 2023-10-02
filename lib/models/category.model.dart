import 'package:bp_tablet_app/models/bpmodel.model.dart';

class BPCategory implements BackPointModel {
  late String ID;
  String _name = "";
  String get Name => _name;
  set Name(String value) {
    _name = value;
  }

  BPCategory({required String id, required String name, String? imageURL}) {
    ID = id;
    _name = name;
  }

  factory BPCategory.fromJson(Map<String, dynamic> json) {
    return BPCategory(id: json['_id'], name: json['Name']);
  }

  @override
  String toString() {
    // TODO: implement toString
    return '$Name (ID: $ID)';
  }
}
