import 'package:bp_tablet_app/environment.dart';
import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/Categories/Categories.APIService.dart';
import 'package:bp_tablet_app/services/APIService/Ingredients/Ingredients.APIService.dart';

class APIService {

  static final CategoriesAPIService _categoriesService = CategoriesAPIService();
  static final IngredientsAPIService _ingredientsService = IngredientsAPIService();

  static Future<List<BPCategory>> getCategories() async => _categoriesService.getCategories();

  static Future<List<BPIngredient>> getIngredients() async => _ingredientsService.getIngredients();
}