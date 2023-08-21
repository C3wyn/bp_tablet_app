import 'package:bp_tablet_app/models/Order/order.model.dart';
import 'package:bp_tablet_app/models/Order/orderstatus.enum.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';

class CartService {
  static BPOrder currentOrder = BPOrder(status: OrderStatus.Created, orderItems: []);
  static void addProduct(BPProduct product, Map<BPIngredient, bool> selectedIngredients){
    currentOrder.AddOrderItem(product: product, selectedIngredients: selectedIngredients);
  }
}