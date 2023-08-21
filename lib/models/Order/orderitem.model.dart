import 'package:bp_tablet_app/models/bpmodel.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';

class BPOrderItem extends BackPointModel {
  BPProduct product;
  Map<BPIngredient, bool> selectedIngredients;
  String? customerDescription;
  BPOrderItem({required this.product, required this.selectedIngredients, this.customerDescription});
}