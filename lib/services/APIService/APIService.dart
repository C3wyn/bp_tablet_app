import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/models/productstatus.enum.dart';
import 'package:bp_tablet_app/services/APIService/Categories/Categories.APIService.dart';
import 'package:bp_tablet_app/services/APIService/DataManager/datamanger.APIService.dart';
import 'package:bp_tablet_app/services/APIService/Ingredients/Ingredients.APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:bp_tablet_app/services/APIService/Products/Products.APIService.dart';
import 'package:file_picker/file_picker.dart';

class APIService {

  static final CategoriesAPIService _categoriesService = CategoriesAPIService();
  static final IngredientsAPIService _ingredientsService = IngredientsAPIService();
  static final ProductsAPIService _productsService = ProductsAPIService();
  static final APIDataManager data = APIDataManager();

  static Future<List<BPIngredient>> getIngredients() async {
    data.ingredients = await  _ingredientsService.getIngredients();
    return data.ingredients;
  }
  static Future<APIResponse> addIngredient(String name) async  => _ingredientsService.addIngredient(name);
  static Future<APIResponse> updateIngredient(BPIngredient ingredient, {required String name}) async => _ingredientsService.updateIngredient(ingredient, name: name);
  static Future<APIResponse> deleteIngredient(BPIngredient ingredient) async => _ingredientsService.deleteIngredient(ingredient);
  
  static Future<List<BPCategory>> getCategories() async {
    data.categories = await _categoriesService.getCategories();
    return data.categories;
  }
  static Future<APIResponse> addCategory(String name, PlatformFile? file) async  => _categoriesService.addCategory(name, file); 
  static Future<APIResponse> updateCategory(BPCategory bpCategory, {required String name}) async => _categoriesService.updateCategory(bpCategory, name);
  static Future<APIResponse> deleteCategory(BPCategory category) async => _categoriesService.deleteCategory(category);

  static Future<List<BPProduct>> getProducts() async {
    data.products = await _productsService.getProducts();
    return data.products;
  }
  static Future<APIResponse> addProduct(
    {
      required String name,
      required double price,
      required BPCategory category,
      required ProductStatus status,
      String? description,
      List<int>? ingredients
    }
  )=> _productsService.addProduct(
    name: name,
    price: price,
    category: category,
    status: status,
    description: description,
    ingredients: ingredients
  );
}