import 'dart:convert';

import 'package:bp_tablet_app/models/ingredient.model.dart';

import '../../../environment.dart';
import 'package:http/http.dart' as http;
class IngredientsAPIService {
  Future<List<BPIngredient>> getIngredients() async {
    var response = await http.get(Uri.parse('http://${BPEnvironment.BASEURL}/ingredients'));
    List<dynamic> data = jsonDecode(response.body)['data'];
    List<BPIngredient> result = [];
    for(var obj in data){
      
      result.add(BPIngredient.fromJson(obj['id'], obj['attributes']));
    }
    return result;
  }
}