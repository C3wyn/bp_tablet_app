import 'package:bp_tablet_app/models/bpmodel.model.dart';

class BPCategory implements BackPointModel {
  int _id = -1;
  String _name = "";

  int get ID => _id;
  String get Name => _name;
  set Name(String value) {
    _name = value;
  }

  BPCategory(
    
    {
      required int id,
      required String name,
      String? imageURL
    }
  ){
    _id = id;
    _name = name;
  }

  factory BPCategory.fromJson(int id, Map<String, dynamic> json) {
    return BPCategory(
      id: id,
      name: json['Name'] as String
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return '$Name (ID: $ID)';
  }
}