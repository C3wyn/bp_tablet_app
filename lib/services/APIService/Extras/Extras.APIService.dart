import 'dart:convert';

import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:file_picker/file_picker.dart';

import '../../../environment.dart';
import 'package:http/http.dart' as http;

class ExtrasAPIService {

  Map<String,String> headers = {
    'Content-Type':'application/json',
    'Accept': 'application/json'
  };

  Future<APIResponse<List<BPExtra>?>> getExtras() async {
    var response = await http.get(Uri.parse('http://${BPEnvironment.BASEURL}/extras'));
    List<dynamic> data = jsonDecode(response.body)['data'];
    List<BPExtra> result = [];
    for(var obj in data){
      result.add(BPExtra.fromJson(obj));
    }
    APIService.data.extras = result;
    if(data.isNotEmpty) {
      return APIResponse<List<BPExtra>>(200, "Successfull", "Alle Extras erfolgreich erhalten", result);
    };
    return APIResponse(500, "Fehlgeschlagen", "Es ist ein Fehler aufgetreten", null);
  }

  Future<APIResponse> addExtra(String name) async {
    String body = jsonEncode({
      "data": {
        "Name": name
      }
    });
    
    var response = await http.post(
      Uri.parse('http://${BPEnvironment.BASEURL}/extras'),
      headers: headers,
      body: body
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if(data['data']!=null){
      BPExtra newextra = BPExtra.fromJson(data['data']);
      APIService.data.extras.add(newextra);
      return APIResponse(
        200,
        "Successfull", 
        "Extra erfolgreich hinzugefügt", 
        newextra
      );
    }
    return APIResponse(data['error']['status'], data['error']['name'], data['error']['message'], null);
  }

  Future<APIResponse> updateExtra(BPExtra extra, {required String name}) async {
    var result = await http.put(
      Uri.parse('http://${BPEnvironment.BASEURL}/extras/${extra.ID}'),
      headers: headers,
      body: jsonEncode({
        "data": {
          "Name": name
        }
      })
    );

    APIResponse response = APIResponse.fromJson(result.body);
    if(response.isSuccess) extra.Name = name;
    return response;
  }

  Future<APIResponse> deleteExtra(BPExtra extra) async {
    var result = await http.delete(
      Uri.parse('http://${BPEnvironment.BASEURL}/extras/${extra.ID}'),
      headers: headers
    );
    var response = APIResponse.fromJson(result.body);

    if(response.isSuccess) APIService.data.extras.remove(extra);

    return response;
  }
}