import 'package:bp_tablet_app/models/bpmodel.model.dart';
import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/productstatus.enum.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';

class BPProduct implements BackPointModel {
  late int _id;
  int get ID => _id;

  late String _name;
  String get Name => _name;

  late List<BPIngredient> _ingredients;
  List<BPIngredient> get Ingredients => _ingredients;

  ProductStatus _status = ProductStatus.None;
  ProductStatus get Status => _status;

  late String _description;
  String get Description => _description;

  late double _price;
  double get Price => _price;

  late BPCategory? _category;
  BPCategory? get Category => _category;

  BPProduct(
    { 
      required int id,
      required String name, 
      required double price,
      String? description,
      BPCategory? category,
      List<BPIngredient>? ingredients,
      ProductStatus? status
    }
  ){
    
    _id = id;
    _name = name;
    _description = description?? "";
    _ingredients = ingredients?? [];
    _status = status?? ProductStatus.None;
    _category = category;
    _price = price;
  }

  factory BPProduct.fromJson(Map<String, dynamic> json) {
    var attributes = json['attributes'];
    List<BPIngredient> ingredients = [];
    for(var ingIDs in attributes['Ingredients']['data']){
      ingredients.add(
        APIService.data.ingredients.firstWhere((BPIngredient ingredient) => ingredient.ID==ingIDs['id'])
      );
    }

    return BPProduct(
      id: json['id'] as int,
      name: attributes['Name'] as String,
      price: double.parse("${attributes['Price']} " ),
      description: attributes['Description'] ,
      category: APIService.data.categories.firstWhere((BPCategory cat) => cat.ID == attributes['Category']['data']['id']),
      ingredients: ingredients,
      status: ProductStatus.values.byName(attributes['Status'] ) 
    );
  }
}