import 'dart:convert';

import 'package:bp_tablet_app/environment.dart';
import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/models/productstatus.enum.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:http/http.dart' as http;
class ProductsAPIService {
  Map<String,String> headers = {
    'Content-Type':'application/json',
    'Accept': 'application/json'
  };

  Future<APIResponse> getProducts() async {
    var response = await http.get(Uri.parse('http://${BPEnvironment.BASEURL}/products?populate=Category,Ingredients'));
    Map<String, dynamic> resp = jsonDecode(response.body);
    List<dynamic> data = resp['data'];
    Map<String, dynamic>? err = resp['error'];
    List<BPProduct> result = [];
    
    for(Map<String, dynamic> obj in data){
      result.add(BPProduct.fromJson(obj)); 
    }

    if(data.isNotEmpty) {
      APIService.data.products = result;
      return APIResponse(200, "Successfull", "Alle Produkte erfolgreich erhalten", result);
    };
    return APIResponse(500, "Fehlgeschlagen", "Es ist ein Fehler aufgetreten", null);
  }
  
  Future<APIResponse> addProduct(
    {
      required String name,
      required double price,
      required BPCategory category,
      required ProductStatus status,
      String? description,
      List<int>? ingredients
    }
  ) async {
    String body = jsonEncode({
      "data": {
        "Name": name,
        "Price": price,
        "Category": category.ID,
        "Status": _productStatusToAPIValue(status),
        "Description": description,
        "Ingredients": ingredients?? []
      }
    });
    var response = await http.post(
      Uri.parse('http://${BPEnvironment.BASEURL}/products?populate=Category,Ingredients'),
      headers: headers,
      body: body
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if(data['data']!=null){
      APIService.data.products.add(BPProduct.fromJson(data['data']));
      return APIResponse(
        200,
        "Successfull", 
        "Produkt erfolgreich hinzugefügt", 
        BPIngredient.fromJson(data['data']['id'], data['data']['attributes'])
      );
    }
    return APIResponse(data['error']['status'], data['error']['name'], data['error']['message'], null);
  }

  String _productStatusToAPIValue(ProductStatus status) {
    String result;
    switch(status){
      case ProductStatus.Archived: result = "Archived"; break;
      case ProductStatus.Available: result = "Available"; break;
      case ProductStatus.SoldOut: result = "SoldOut"; break;
      default: result = "None"; 
    }
    return result;
  }
  /*
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
  */
}