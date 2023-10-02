import 'package:bp_tablet_app/models/bpmodel.model.dart';
import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/productstatus.enum.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';

class BPProduct implements BackPointModel {
  late String ID;

  late String _name;
  String get Name => _name;
  set Name(String value) => _name = value;

  late List<BPIngredient> _ingredients;
  List<BPIngredient> get Ingredients => _ingredients;
  set Ingredients(List<BPIngredient> ingredients) => _ingredients = ingredients;

  ProductStatus _status = ProductStatus.None;
  ProductStatus get Status => _status;
  set Status(ProductStatus status) => _status = status;

  late String _description;
  String get Description => _description;
  set Description(String value) => _description = value;

  late double _price;
  double get Price => _price;
  set Price(double value) => _price = value;

  late BPCategory? _category;
  BPCategory? get Category => _category;
  set Category(BPCategory? value) => _category = value;

  late List<BPExtra> Extras;

  BPProduct(
      {required String id,
      required String name,
      required double price,
      String? description,
      BPCategory? category,
      List<BPIngredient>? ingredients,
      ProductStatus? status,
      List<BPExtra>? extras}) {
    ID = id;
    _name = name;
    _description = description ?? "";
    _ingredients = ingredients ?? [];
    _status = status ?? ProductStatus.None;
    _category = category;
    _price = price;
    Extras = extras ?? [];
  }

  factory BPProduct.fromJson(Map<String, dynamic> json) {
    List<BPIngredient> ingredients = [];
    if (json['Ingredients']?.isNotEmpty ?? false) {
      try {
        for (var ingIDs in json['Ingredients']) {
          ingredients.add(APIService.data.ingredients
              .firstWhere((BPIngredient ing) => ing.ID == ingIDs));
        }
      } catch (err) {
        print(err);
      }
    }
    List<BPExtra> extras = [];
    if (json['Extras']?.isNotEmpty ?? false) {
      for (var extra in json['Extras']) {
        try {
          print(extra);
          for (var e in APIService.data.extras) print(e.ID);
          extras.add(APIService.data.extras
              .where((BPExtra ext) => ext.ID == extra)
              .first);
        } catch (err) {
          print(err);
        }
      }
    }

    BPCategory? category;
    if (json['Category']?.isNotEmpty ?? false) {
      category = APIService.data.categories
          .firstWhere((BPCategory cat) => cat.ID == json['Category']);
    }

    return BPProduct(
        id: json['_id'],
        name: json['Name'] as String,
        price: double.parse("${json['Price']} "),
        description: json['Description'],
        category: category,
        ingredients: ingredients,
        status: ProductStatus.values.byName(json['Status']),
        extras: extras);
  }
}
