import 'dart:io';

import 'package:bp_tablet_app/environment.dart';
import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/Categories/Categories.APIService.dart';
import 'package:bp_tablet_app/services/APIService/DataManager/datamanger.APIService.dart';
import 'package:bp_tablet_app/services/APIService/Ingredients/Ingredients.APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';

class APIService {

  static final CategoriesAPIService _categoriesService = CategoriesAPIService();
  static final IngredientsAPIService _ingredientsService = IngredientsAPIService();
  static final APIDataManager data = APIDataManager();

  static Future<List<BPCategory>> getCategories() async {
    data.categories = await _categoriesService.getCategories();
    return data.categories;
  }

  static Future<List<BPIngredient>> getIngredients() async {
    data.ingredients = await  _ingredientsService.getIngredients();
    return data.ingredients;
  }

  static Future<APIResponse> addIngredient(String name) async  => _ingredientsService.addIngredient(name);
}