import 'package:bp_tablet_app/models/bpmodel.model.dart';

class BPExtra implements BackPointModel{
  late int ID;
  late String Name;

  BPExtra({
    required this.ID,
    required this.Name,
  });

  factory BPExtra.fromJson(Map<String, dynamic> json) {
    if(isMapInExpectedFormat(json)){
      return BPExtra(
        ID: json['id'] as int,
        Name: json['attributes']['Name'],
      );
    }
    throw Exception("Map is not in the expected format");
  }

  static bool isMapInExpectedFormat(Map<String, dynamic> inputMap) {
  // Check if the map contains the "id" key with a numeric value
  if (!inputMap.containsKey("id") || inputMap["id"] is! int) {
    return false;
  }

  // Check if the map contains the "attributes" key with a submap
  if (!inputMap.containsKey("attributes") || inputMap["attributes"] is! Map) {
    return false;
  }

  // Check if the "attributes" submap contains the required keys
  Map<String, dynamic> attributesMap = inputMap["attributes"];
  if (!attributesMap.containsKey("Name")) {
    return false;
  }

  // Check the types of the values for "Name", "createdAt", and "updatedAt"
  if (attributesMap["Name"] is! String ) {
    return false;
  }

  // If all checks pass, the map is in the expected format
  return true;
}
}