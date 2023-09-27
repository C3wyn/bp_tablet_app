import 'dart:convert';

import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:file_picker/file_picker.dart';

import '../../../environment.dart';
import 'package:http/http.dart' as http;

class CategoriesAPIService {

  Map<String,String> headers = {
    'Content-Type':'application/json',
    'Accept': 'application/json'
  };

  Future<APIResponse<List<BPCategory>?>> getCategories() async {
    var response = await http.get(Uri.parse('http://${BPEnvironment.BASEURL}/categories'));
    List<dynamic> data = jsonDecode(response.body)['data'];
    List<BPCategory> result = [];
    for(var obj in data){
      result.add(BPCategory.fromJson(obj['id'], obj['attributes']));
    }
    APIService.data.categories = result;
    if(response.statusCode==200) {
      return APIResponse<List<BPCategory>>(200, "Successfull", "Alle Produkte erfolgreich erhalten", result);
    };
    return APIResponse(500, "Fehlgeschlagen", "Es ist ein Fehler aufgetreten", null);
  }

  Future<APIResponse> addCategory(String name, PlatformFile? file) async {
    String body = jsonEncode({
      "data": {
        "Name": name
      }
    });
    
    var response = await http.post(
      Uri.parse('http://${BPEnvironment.BASEURL}/categories'),
      headers: headers,
      body: body
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if(data['data']!=null){
      APIService.data.categories.add(BPCategory(id: data['data']['id'], name: name));
      return APIResponse(
        200,
        "Successfull", 
        "Zutat erfolgreich hinzugefügt", 
        BPCategory.fromJson(data['data']['id'], data['data']['attributes'])
      );
    }
    return APIResponse(data['error']['status'], data['error']['name'], data['error']['message'], null);
  }

  Future<APIResponse> updateCategory(BPCategory bpCategory, String name) async {
    var result = await http.put(
      Uri.parse('http://${BPEnvironment.BASEURL}/categories/${bpCategory.ID}'),
      headers: headers,
      body: jsonEncode({
        "data": {
          "Name": name
        }
      })
    );

    APIResponse response = APIResponse.fromJson(result.body);
    if(response.Code == 200) bpCategory.Name = name;
    return response;
  }

  Future<APIResponse> deleteCategory(BPCategory category) async {
    var result = await http.delete(
      Uri.parse('http://${BPEnvironment.BASEURL}/categories/${category.ID}'),
      headers: headers
    );
    var response = APIResponse.fromJson(result.body);

    if(response.isSuccess) APIService.data.categories.remove(category);

    return response;
  }
}