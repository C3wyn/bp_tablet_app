import 'package:bp_tablet_app/models/Order/order.model.dart';
import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/models/productstatus.enum.dart';
import 'package:bp_tablet_app/services/APIService/Categories/Categories.APIService.dart';
import 'package:bp_tablet_app/services/APIService/DataManager/datamanger.APIService.dart';
import 'package:bp_tablet_app/services/APIService/Ingredients/Ingredients.APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:bp_tablet_app/services/APIService/Orders/Orders.APIService.dart';
import 'package:bp_tablet_app/services/APIService/Products/Products.APIService.dart';
import 'package:file_picker/file_picker.dart';

class APIService {

  static final CategoriesAPIService _categoriesService = CategoriesAPIService();
  static final IngredientsAPIService _ingredientsService = IngredientsAPIService();
  static final ProductsAPIService _productsService = ProductsAPIService();
  static final OrdersAPIService _orderService = OrdersAPIService();
  static final APIDataManager data = APIDataManager();

  static Future<APIResponse<List<BPIngredient>?>> getIngredients() => _handleErrors<List<BPIngredient>?>(_ingredientsService.getIngredients());
  static Future<APIResponse> addIngredient(String name) async  => _ingredientsService.addIngredient(name);
  static Future<APIResponse> updateIngredient(BPIngredient ingredient, {required String name}) async => _ingredientsService.updateIngredient(ingredient, name: name);
  static Future<APIResponse> deleteIngredient(BPIngredient ingredient) async => _ingredientsService.deleteIngredient(ingredient);
  
  static Future<APIResponse<List<BPCategory>?>> getCategories() => _handleErrors(_categoriesService.getCategories());

  static Future<APIResponse> addCategory(String name, PlatformFile? file) async  => _categoriesService.addCategory(name, file); 
  static Future<APIResponse> updateCategory(BPCategory bpCategory, {required String name}) async => _categoriesService.updateCategory(bpCategory, name);
  static Future<APIResponse> deleteCategory(BPCategory category) async => _categoriesService.deleteCategory(category);

  static Future<APIResponse> getProducts() => _handleErrors(_productsService.getProducts());
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

  static Future<APIResponse> addOrder(BPOrder order) => _handleErrors(_orderService.addOrder(order));

  static Future<APIResponse<t>> _handleErrors<t>(Future<APIResponse<t>> next) async {
    try {
      var response = await next;
      return response;
    }catch(error){
      print(error);
      return APIResponse(
        500,
        "Fehlgeschlagen",
        error.toString(),
        null
      );
    }
  }
}