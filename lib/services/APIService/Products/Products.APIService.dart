import 'dart:convert';
import 'package:bp_tablet_app/environment.dart';
import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/models/productstatus.enum.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:http/http.dart' as http;

class ProductsAPIService {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<APIResponse> getProducts() async {
    var response =
        await http.get(Uri.parse('http://${BPEnvironment.BASEURL}/products'));
    List<dynamic> data = jsonDecode(response.body);

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
        500, "Fehlgeschlagen", "Es ist ein Fehler aufgetreten", null);
  }

  Future<APIResponse> addProduct(
      {required String name,
      required double price,
      BPCategory? category,
      required ProductStatus status,
      String? description,
      List<String>? ingredients,
      List<String>? extras}) async {
    String body = jsonEncode({
      "Name": name,
      "Price": price,
      "Category": category?.ID,
      "Status": _productStatusToAPIValue(status),
      "Description": description,
      "Ingredients": ingredients ?? [],
      "Extras": extras ?? []
    });
    var response = await http.post(
        Uri.parse('http://${BPEnvironment.BASEURL}/product'),
        headers: headers,
        body: body);

    List<BPIngredient> ingIds = [];
    for (String ingId in ingredients ?? []) {
      ingIds.add(APIService.data.ingredients
          .firstWhere((element) => element.ID == ingId));
    }
    List<BPExtra> extraIds = [];
    for (String extraId in extras ?? []) {
      extraIds.add(APIService.data.extras
          .firstWhere((element) => element.ID == extraId));
    }

    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['acknowledged'] == true) {
      var newProduct = BPProduct(
        id: data['insertedId'],
        name: name,
        price: price,
        description: description,
        category: category,
        ingredients: ingIds,
        status: status,
        extras: extraIds,
      );
      APIService.data.products.add(newProduct);
      return APIResponse(
          200, "Successfull", "Produkt erfolgreich hinzugefügt", newProduct);
    }
    return APIResponse(
        500, 'Fehlgeschlagen', 'Ups ein Fehler ist aufgetreten', null);
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
      String id,
      String name,
      double price,
      ProductStatus status,
      BPCategory? category,
      String? description,
      List<BPIngredient>? ingredients,
      List<BPExtra>? extras) async {
    List<String> ingIds = [];
    for (BPIngredient ing in ingredients ?? []) {
      ingIds.add(ing.ID);
    }

    List<String> extraIds = [];
    for (BPExtra extra in extras ?? []) {
      extraIds.add(extra.ID);
    }

    String body = jsonEncode({
      "Name": name,
      "Price": price,
      "Category": category?.ID,
      "Status": _productStatusToAPIValue(status),
      "Description": description,
      "Ingredients": ingIds ?? [],
      "Extras": extraIds ?? []
    });

    var result = await http.put(
        Uri.parse('http://${BPEnvironment.BASEURL}/product/$id'),
        headers: headers,
        body: body);

    print(result.body);
    Map<String, dynamic> data = jsonDecode(result.body);

    if (data['acknowledged'] == true && result.statusCode == 200) {
      BPProduct product =
          APIService.data.products.firstWhere((x) => x.ID == id);
      product.Name = name as String;
      product.Price = double.parse("${price} ");
      product.Description = description ?? "";
      product.Category = category;
      product.Ingredients = ingredients ?? [];
      product.Status = status;
      product.Extras = extras ?? [];
      return APIResponse(result.statusCode, "Successfull",
          "Produkt erfolgreich geändert", product);
    }
    throw Exception(data['msg']);
  }

  Future<APIResponse> deleteProduct(BPProduct product) async {
    var result = await http.delete(
        Uri.parse('http://${BPEnvironment.BASEURL}/product/${product.ID}'),
        headers: headers);
    var response = APIResponse.fromJson(result.body);
    if (result.statusCode == 200) APIService.data.products.remove(product);

    return response;
  }
}
