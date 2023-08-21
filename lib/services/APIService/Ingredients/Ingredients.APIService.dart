import 'dart:convert';
import 'dart:io';

import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';

import '../../../environment.dart';
import 'package:http/http.dart' as http;
class IngredientsAPIService {

  Map<String,String> headers = {
    'Content-Type':'application/json',
    'Accept': 'application/json'
  };

  Future<APIResponse<List<BPIngredient>?>> getIngredients() async {
    var response = await http.get(Uri.parse('http://${BPEnvironment.BASEURL}/ingredients'));
    List<dynamic> data = jsonDecode(response.body)['data'];
    List<BPIngredient> result = [];

    
    for(var obj in data){
      result.add(BPIngredient.fromJson(obj['id'], obj['attributes']));
    }
    
    if(data.isNotEmpty) {
      APIService.data.ingredients = result;
      return APIResponse<List<BPIngredient>>(200, "Successfull", "Alle Produkte erfolgreich erhalten", result);
    };
    return APIResponse<List<BPIngredient>>(500, "Fehlgeschlagen", "Es ist ein Fehler aufgetreten", null);
  }

  Future<APIResponse> addIngredient(String name) async {
    String body = jsonEncode({
      "data": {
        "Name": name
      }
    });
    
    var response = await http.post(
      Uri.parse('http://${BPEnvironment.BASEURL}/ingredients'),
      headers: headers,
      body: body
    );
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

  Future<APIResponse> updateIngredient(BPIngredient updatedIngredient, {required String name}) async {

    var result = await http.put(
      Uri.parse('http://${BPEnvironment.BASEURL}/ingredients/${updatedIngredient.ID}'),
      headers: headers,
      body: jsonEncode({
        "data": {
          "Name": name
        }
      })
    );

    APIResponse response = APIResponse.fromJson(result.body);
    if(response.Code == 200) updatedIngredient.Name = name;
    return response;
  }

  Future<APIResponse> deleteIngredient(BPIngredient ingredient) async {
    var result = await http.delete(
      Uri.parse('http://${BPEnvironment.BASEURL}/ingredients/${ingredient.ID}'),
      headers: headers
    );
    var response = APIResponse.fromJson(result.body);

    if(response.Code == 200) APIService.data.ingredients.remove(ingredient);

    return response;
  }
}