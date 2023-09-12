import 'package:bp_tablet_app/models/bpmodel.model.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';

class BPOrderItem extends BackPointModel {
  BPProduct product;
  Map<BPIngredient, bool> selectedIngredients;
  Map<BPExtra, bool> selectedExtras;
  String? customerDescription;
  BPOrderItem({required this.product, required this.selectedIngredients, required this.selectedExtras, this.customerDescription});
}