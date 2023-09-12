import 'dart:convert';

import 'package:bp_tablet_app/environment.dart';
import 'package:bp_tablet_app/models/Order/order.model.dart';
import 'package:bp_tablet_app/models/Order/orderdeliverytype.enum.dart';
import 'package:bp_tablet_app/models/Order/orderitem.model.dart';
import 'package:bp_tablet_app/models/Order/orderstatus.enum.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:bp_tablet_app/services/CartService/Cart.service.dart';
import 'package:http/http.dart' as http;
class OrdersAPIService {
  Map<String,String> headers = {
    'Content-Type':'application/json',
    'Accept': 'application/json'
  };
  Future<APIResponse> addOrder(BPOrder order) async {
    String body = _orderToJson(order);
    var response = await http.post(
      Uri.parse('http://localhost:1337/backpoint/createOrder'),
      headers: headers,
      body: body
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    if(response.statusCode==200){
      CartService.currentOrder = BPOrder(status: OrderStatus.Created, orderItems: []);
      return APIResponse(
        200,
        "Successfull", 
        "Produkt erfolgreich hinzugefügt",
        null
      );
    }
    return APIResponse(data['error']['status'], data['error']['name'], data['error']['message'], null);
  }
  
  String _orderToJson(BPOrder order) {
    var items = [];
    for(BPOrderItem item in order.orderItems){
      var ingredients = [];
      for(BPIngredient ingredient in item.selectedIngredients.keys.where((x) => !item.selectedIngredients[x]!)){
        ingredients.add(
          {
            "Name": ingredient.Name,
            "Selected": item.selectedIngredients[ingredient],
            "Default": true
          }
        );
      }
      var extras = [];
      for(BPExtra extra in item.selectedExtras.keys.where((x) => item.selectedExtras[x]!)){
        extras.add({"Name": extra.Name});
      }

      items.add({
        "productID": item.product.ID,
        "selectedIngredients": ingredients,
        "selectedExtras": extras,
        "customerDescription": item.customerDescription
      });
    }
    
    return jsonEncode({
      "data": {
        "id": order.id,
        "items": items,
        "pickUpDate": order.pickUpDate?? DateTime.now().toUtc().toString(),
        "deliveryType": order.deliveryType==OrderDeliveryType.EatHere? 2: 1,
        "orderDescription": order.orderDescription
      }
    });
  }
}