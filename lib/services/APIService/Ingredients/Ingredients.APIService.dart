import 'dart:convert';
import 'dart:io';

import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';

import '../../../environment.dart';
import 'package:http/http.dart' as http;

class IngredientsAPIService {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<APIResponse<List<BPIngredient>?>> getIngredients() async {
    var response = await http
        .get(Uri.parse('http://${BPEnvironment.BASEURL}/ingredients'));
    List<dynamic> data = jsonDecode(response.body);
    List<BPIngredient> result = [];

    for (var obj in data) {
      result.add(BPIngredient.fromJson(obj));
    }
    APIService.data.ingredients = result;
    if (response.statusCode == 200) {
      return APIResponse<List<BPIngredient>>(
          200, "Successfull", "Alle Produkte erfolgreich erhalten", result);
    }
    ;
    return APIResponse<List<BPIngredient>>(
        500, "Fehlgeschlagen", "Es ist ein Fehler aufgetreten", null);
  }

  Future<APIResponse> addIngredient(String name) async {
    String body = jsonEncode({"Name": name});

    var response = await http.post(
        Uri.parse('http://${BPEnvironment.BASEURL}/ingredients'),
        headers: headers,
        body: body);
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['acknowledged'] == true) {
      BPIngredient newIngredient = BPIngredient(data['insertedId'], name);
      APIService.data.ingredients.add(newIngredient);
      return APIResponse(
          200, "Successfull", "Zutat erfolgreich hinzugefügt", newIngredient);
    }
    return APIResponse(response.statusCode, data['error']['name'],
        data['error']['message'], null);
  }

  Future<APIResponse> updateIngredient(BPIngredient updatedIngredient,
      {required String name}) async {
    var result = await http.put(
        Uri.parse(
            'http://${BPEnvironment.BASEURL}/ingredients/${updatedIngredient.ID}'),
        headers: headers,
        body: jsonEncode({"Name": name}));

    APIResponse response = APIResponse.fromJson(result.body);
    if (response.Code == 200) updatedIngredient.Name = name;
    return response;
  }

  Future<APIResponse> deleteIngredient(BPIngredient ingredient) async {
    var result = await http.delete(
        Uri.parse(
            'http://${BPEnvironment.BASEURL}/ingredients/${ingredient.ID}'),
        headers: headers);
    var response = APIResponse.fromJson(result.body);

    if (response.Code == 200) APIService.data.ingredients.remove(ingredient);

    return response;
  }
}
