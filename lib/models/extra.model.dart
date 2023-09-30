import 'package:bp_tablet_app/models/bpmodel.model.dart';

class BPExtra implements BackPointModel {
  late String ID;
  late String Name;

  BPExtra({
    required this.ID,
    required this.Name,
  });

  factory BPExtra.fromJson(Map<String, dynamic> json) {
    return BPExtra(
      ID: json['_id'],
      Name: json['Name'],
    );
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
    if (attributesMap["Name"] is! String) {
      return false;
    }

    // If all checks pass, the map is in the expected format
    return true;
  }
}
