import 'dart:convert';
import 'dart:io';

import 'package:bp_tablet_app/environment.dart';
import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/models/productstatus.enum.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProductsAPIService {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<APIResponse> getProducts() async {
    var response = await http.get(Uri.parse(
        'http://${BPEnvironment.BASEURL}/products?populate=Category,Ingredients,Extras'));
    Map<String, dynamic> resp = jsonDecode(response.body);
    List<dynamic> data = resp['data'];
    Map<String, dynamic>? err = resp['error'];
    List<BPProduct> result = [];

    for (Map<String, dynamic> obj in data) {
      result.add(BPProduct.fromJson(obj));
    }
    APIService.data.products = result;
    if (response.statusCode == 200) {
      return APIResponse(
          200, "Successfull", "Alle Produkte erfolgreich erhalten", result);
    }
    ;
    return APIResponse(
        500, "Fehlgeschlagen", "Es ist ein Fehler aufgetreten (PRO)", null);
  }

  Future<APIResponse> addProduct(
      {required String name,
      required double price,
      required BPCategory category,
      required ProductStatus status,
      String? description,
      List<int>? ingredients,
      List<String>? extras}) async {
    String body = jsonEncode({
      "data": {
        "Name": name,
        "Price": price,
        "Category": category.ID,
        "Status": _productStatusToAPIValue(status),
        "Description": description,
        "Ingredients": ingredients ?? [],
        "Extras": extras ?? []
      }
    });
    var response = await http.post(
        Uri.parse('http://${BPEnvironment.BASEURL}/products'),
        headers: headers,
        body: body);

    print(response.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['data'] != null) {
      APIService.data.products.add(BPProduct.fromJson(data['data']));
      return APIResponse(
          200,
          "Successfull",
          "Produkt erfolgreich hinzugefügt",
          BPIngredient.fromJson(
              data['data']['id'], data['data']['attributes']));
    }
    return APIResponse(data['error']['status'], data['error']['name'],
        data['error']['message'], null);
  }

  String _productStatusToAPIValue(ProductStatus status) {
    String result;
    switch (status) {
      case ProductStatus.Archived:
        result = "Archived";
        break;
      case ProductStatus.Available:
        result = "Available";
        break;
      case ProductStatus.SoldOut:
        result = "SoldOut";
        break;
      default:
        result = "None";
    }
    return result;
  }

  Future<APIResponse> updateProduct(
      int id,
      String name,
      double price,
      BPCategory category,
      ProductStatus status,
      String? description,
      List<int>? ingredients,
      List<String>? extras) async {
    String body = jsonEncode({
      "data": {
        "Name": name,
        "Price": price,
        "Category": category.ID,
        "Status": _productStatusToAPIValue(status),
        "Description": description,
        "Ingredients": ingredients ?? [],
        "Extras": extras ?? []
      }
    });

    var result = await http.put(
        Uri.parse(
            'http://${BPEnvironment.BASEURL}/products/$id?populate=Category,Ingredients,Extras'),
        headers: headers,
        body: body);

    Map<String, dynamic> data = jsonDecode(result.body)['data'];
    Map<String, dynamic>? err = jsonDecode(result.body)['error'];

    if (err == null) {
      BPProduct product =
          APIService.data.products.firstWhere((x) => x.ID == id);
      var attributes = data['attributes'];
      List<BPIngredient> ingredients = [];
      for (var ingIDs in attributes['Ingredients']['data']) {
        ingredients.add(APIService.data.ingredients.firstWhere(
            (BPIngredient ingredient) => ingredient.ID == ingIDs['id']));
      }
      List<BPExtra> extras = [];
      for (var extraIDs in attributes['Extras']['data']) {
        extras.add(APIService.data.extras
            .firstWhere((extra) => extra.ID == extraIDs['id']));
      }
      product.ID = data['id'] as int;
      product.Name = attributes['Name'] as String;
      product.Price = double.parse("${attributes['Price']} ");
      product.Description = attributes['Description'];
      product.Category = APIService.data.categories.firstWhere(
          (BPCategory cat) => cat.ID == attributes['Category']['data']['id']);
      product.Ingredients = ingredients;
      product.Status = ProductStatus.values.byName(attributes['Status']);
      product.Extras = extras;
      return APIResponse(result.statusCode, "Successfull",
          "Produkt erfolgreich geändert", product);
    }
    throw Error();
  }

  Future<APIResponse> deleteProduct(BPProduct product) async {
    var result = await http.delete(
        Uri.parse('http://${BPEnvironment.BASEURL}/products/${product.ID}'),
        headers: headers);
    var response = APIResponse.fromJson(result.body);

    if (result.statusCode == 200) APIService.data.products.remove(product);

    return response;
  }
}
