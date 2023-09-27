import 'package:bp_tablet_app/models/Order/order.model.dart';
import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/models/productstatus.enum.dart';
import 'package:bp_tablet_app/services/APIService/Categories/Categories.APIService.dart';
import 'package:bp_tablet_app/services/APIService/DataManager/datamanger.APIService.dart';
import 'package:bp_tablet_app/services/APIService/Extras/Extras.APIService.dart';
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
  static final ExtrasAPIService _extrasService = ExtrasAPIService();
  static final APIDataManager data = APIDataManager();

  static Future<APIResponse<List<BPIngredient>?>> getIngredients() => _handleErrors<List<BPIngredient>?>(_ingredientsService.getIngredients());
  static Future<APIResponse> addIngredient(String name) async  => _handleErrors(_ingredientsService.addIngredient(name));
  static Future<APIResponse> updateIngredient(BPIngredient ingredient, {required String name}) async => _handleErrors(_ingredientsService.updateIngredient(ingredient, name: name));
  static Future<APIResponse> deleteIngredient(BPIngredient ingredient) async => _handleErrors(_ingredientsService.deleteIngredient(ingredient));
  
  static Future<APIResponse<List<BPCategory>?>> getCategories() => _handleErrors(_categoriesService.getCategories());

  static Future<APIResponse> addCategory(String name, PlatformFile? file) async  => _handleErrors(_categoriesService.addCategory(name, file)); 
  static Future<APIResponse> updateCategory(BPCategory bpCategory, {required String name}) async => _handleErrors(_categoriesService.updateCategory(bpCategory, name));
  static Future<APIResponse> deleteCategory(BPCategory category) async => _handleErrors(_categoriesService.deleteCategory(category));

  static Future<APIResponse> getProducts() => _productsService.getProducts();
  static Future<APIResponse> addProduct(
    {
      required String name,
      required double price,
      required BPCategory category,
      required ProductStatus status,
      String? description,
      List<int>? ingredients,
      List<int>? extras
    }
  )=> _handleErrors(_productsService.addProduct(
    name: name,
    price: price,
    category: category,
    status: status,
    description: description,
    ingredients: ingredients,
    extras: extras
  ));
  static Future<APIResponse> updateProduct(
    {
      required int id, 
      required String name,
      required double price,
      required BPCategory category,
      required ProductStatus status,
      String? description,
      List<int>? ingredients,
      List<int>? extras
    }) => _handleErrors(_productsService.updateProduct(id, name, price, category, status, description, ingredients, extras));
  static Future<APIResponse> deleteProduct(BPProduct product) async => _handleErrors(_productsService.deleteProduct(product));


  static Future<APIResponse> addOrder(BPOrder order) => _handleErrors(_orderService.addOrder(order));

  static Future<APIResponse> getExtras() => _extrasService.getExtras();
  static Future<APIResponse> addExtra(String name) async  => _handleErrors(_extrasService.addExtra(name));
  static Future<APIResponse> updateExtra(BPExtra, {required String name}) async => _handleErrors(_extrasService.updateExtra(BPExtra, name: name));
  static Future<APIResponse> deleteExtra(BPExtra extra) async => _handleErrors(_extrasService.deleteExtra(extra));

  static Future<APIResponse<t>> _handleErrors<t>(Future<APIResponse<t>> next) async {
    try {
      var response = await next;
      if(response.isSuccess) return response;
      throw Error();
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