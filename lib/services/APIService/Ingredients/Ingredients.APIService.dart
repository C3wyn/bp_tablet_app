import 'dart:convert';
import 'dart:io';

import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';

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

  Future<APIResponse> addIngredient(String name) async {
    var body = jsonEncode({
      "data": {
        "Name": name
      }
    });
    Map<String,String> headers = {
      'Content-Type':'application/json',
      'Accept': 'application/json'
    };
    var response = await http.post(
      Uri.parse('http://${BPEnvironment.BASEURL}/ingredients'),
      headers: headers,
      body: body
    );
    print(response.body);
    Map<String, dynamic> data = jsonDecode(response.body);
    if(data['data']!=null){
      APIService.data.ingredients.add(BPIngredient(data['data']['id'], name));
      return APIResponse(
        200,
        "Successfull", 
        "Zutat erfolgreich hinzugefügt", 
        BPIngredient.fromJson(data['data']['id'], data['data']['attributes'])
      );
    }
    return APIResponse(data['error']['status'], data['error']['name'], data['error']['message'], null);
  }
}