import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Categories/Categories.APIService.dart';
import 'package:flutter_test/flutter_test.dart';

void TestCategoriesAPIService() {
  group('CategoriesAPIService', () {
    CategoriesAPIService categoriesAPIService = CategoriesAPIService();
    BPCategory? category;

    test('addCategory should add a new category', () async {
      String newName = 'Test Category';
      var response = await categoriesAPIService.addCategory(newName);
      expect(response.isSuccess, true);
      expect(APIService.data.categories.last.Name, newName);
    });

    test('should get a list of categories', () async {
      var response = await categoriesAPIService.getCategories();
      expect(response.isSuccess, true);
      expect(APIService.data.categories.length, greaterThan(0));
    });

    test('updateCategory should update an existing category', () async {
      String categoryName = 'Updated Test Category';
      category = APIService.data.categories[0];
      var response =
          await categoriesAPIService.updateCategory(category!, categoryName);
      expect(response.isSuccess, true);
      expect(APIService.data.categories[0].Name, categoryName);
    });

    test('deleteCategory should delete an existing category', () async {
      var response = await categoriesAPIService.deleteCategory(category!);
      expect(response.isSuccess, true);
      expect(
          APIService.data.categories.where((x) => x.ID == category!.ID).length,
          equals(0));
    });
  });
}
