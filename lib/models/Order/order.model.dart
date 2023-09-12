import 'dart:io';
import 'package:bp_tablet_app/models/Order/orderdeliverytype.enum.dart';
import 'package:bp_tablet_app/models/Order/orderitem.model.dart';
import 'package:bp_tablet_app/models/Order/orderstatus.enum.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';

class BPOrder {
  int? id;
  late OrderStatus status;
  late List<BPOrderItem> orderItems;
  late String? orderDescription;
  late OrderDeliveryType? deliveryType;
  late DateTime? pickUpDate;
  late DateTime? acceptedTime;
  late DateTime? finishedTime;

  BPOrder({
    required this.status,
    required this.orderItems,
    this.id,
    this.orderDescription,
    this.deliveryType,
    this.pickUpDate,
    this.acceptedTime,
    this.finishedTime
  });

  void addOrderItem({required BPProduct product, required Map<BPIngredient, bool> selectedIngredients, required Map<BPExtra, bool> selectedExtras, String? description} ){
    orderItems.add(
      BPOrderItem(
        product: product, 
        selectedIngredients: selectedIngredients, 
        selectedExtras: selectedExtras, 
        customerDescription: description
      )
    );
  }
}