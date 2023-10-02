import 'dart:convert';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';

import '../../../environment.dart';
import 'package:http/http.dart' as http;

class ExtrasAPIService {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*'
  };

  Future<APIResponse<List<BPExtra>?>> getExtras() async {
    var response =
        await http.get(Uri.parse('http://${BPEnvironment.BASEURL}/extras'));
    List<dynamic> data = jsonDecode(response.body);
    List<BPExtra> result = [];
    for (var obj in data) {
      result.add(BPExtra.fromJson(obj));
    }
    print(result);
    APIService.data.extras = result;
    if (response.statusCode == 200) {
      return APIResponse<List<BPExtra>>(
          200, "Successfull", "Alle Extras erfolgreich erhalten", result);
    }
    return APIResponse<List<BPExtra>>(
        response.statusCode, 'Fehler', "Fehler beim erhalten der Extras", null);
  }

  Future<APIResponse> addExtra(String name) async {
    String body = jsonEncode({"Name": name});

    var response = await http.post(
        Uri.parse('http://${BPEnvironment.BASEURL}/extra'),
        headers: headers,
        body: body);
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['acknowledged'] == true) {
      APIService.data.extras.add(BPExtra(ID: data['insertedId'], Name: name));
      return APIResponse(
          200, "Successfull", "Extra erfolgreich hinzugefügt", null);
    }
    return APIResponse(data['error']['status'], data['error']['name'],
        data['error']['message'], null);
  }

  Future<APIResponse> updateExtra(BPExtra extra, {required String name}) async {
    var result = await http.put(
        Uri.parse('http://${BPEnvironment.BASEURL}/extra/${extra.ID}'),
        headers: headers,
        body: jsonEncode({"Name": name}));

    APIResponse response = APIResponse.fromJson(result.body);
    if (response.isSuccess) extra.Name = name;
    return response;
  }

  Future<APIResponse> deleteExtra(BPExtra extra) async {
    var result = await http.delete(
        Uri.parse('http://${BPEnvironment.BASEURL}/extra/${extra.ID}'),
        headers: headers);
    var response = APIResponse.fromJson(result.body);

    if (response.isSuccess) APIService.data.extras.remove(extra);

    return response;
  }
}
