import 'dart:convert';

import 'package:bp_tablet_app/models/category.model.dart';

import '../../../environment.dart';
import 'package:http/http.dart' as http;

class CategoriesAPIService {
  Future<List<BPCategory>> getCategories() async {
    var response = await http.get(Uri.parse('http://${BPEnvironment.BASEURL}/categories'));
    List<dynamic> data = jsonDecode(response.body)['data'];
    List<BPCategory> result = [];
    for(var obj in data){
      
      result.add(BPCategory.fromJson(obj['id'], obj['attributes']));
    }
    return result;
  }
}