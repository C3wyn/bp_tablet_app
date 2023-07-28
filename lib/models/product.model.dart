import 'package:bp_tablet_app/models/bpmodel.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/productstatus.enum.dart';

class BPProduct implements BackPointModel {
  late String _id;

  String get ID => _id;

  late String _name;

  String get Name => _name;

  List<BPIngredient> _ingredients = [];

  List<BPIngredient> get Ingredients => _ingredients;

  ProductStatus _status = ProductStatus.None;

  ProductStatus get Status => _status;

  BPProduct(
    String id,
    String name, 
    { 
      List<BPIngredient>? ingredients,
      ProductStatus? status
    }
  ){
    
    _id = id;
    _name = name;
    if(ingredients != null){ _ingredients = ingredients;}
    if(status != null) _status = status;
  }
}