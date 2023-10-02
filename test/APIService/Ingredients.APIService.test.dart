import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Ingredients/Ingredients.APIService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bp_tablet_app/services/APIService/Extras/Extras.APIService.dart';

void TestIngredientsAPIService() {
  group('IngredientsAPIService', () {
    IngredientsAPIService ingredientsAPIService = IngredientsAPIService();
    BPIngredient? ingredient;

    test('addIngredients should add a new ingredient', () async {
      String newName = 'Test Ingredient';
      var response = await ingredientsAPIService.addIngredient(newName);
      expect(response.isSuccess, true);
      expect(APIService.data.ingredients.last.Name, newName);
    });

    test('should get a list of ingredients', () async {
      var response = await ingredientsAPIService.getIngredients();
      expect(response.isSuccess, true);
      expect(APIService.data.ingredients.length, greaterThan(0));
    });

    test('updateIngredient should update an existing ingredient', () async {
      String ingredientName = 'Updated Test Ingredient';
      ingredient = APIService.data.ingredients[0];
      var response = await ingredientsAPIService.updateIngredient(ingredient!,
          name: ingredientName);
      expect(response.isSuccess, true);
      expect(APIService.data.ingredients[0].Name, ingredientName);
    });

    test('deleteIngredient should delete an existing ingredient', () async {
      var response = await ingredientsAPIService.deleteIngredient(ingredient!);
      expect(response.isSuccess, true);
      expect(
          APIService.data.ingredients
              .where((x) => x.ID == ingredient!.ID)
              .length,
          equals(0));
    });
  });
}
