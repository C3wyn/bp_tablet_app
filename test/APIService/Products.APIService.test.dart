import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/models/productstatus.enum.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Products/Products.APIService.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestProductsAPIService();
}

void TestProductsAPIService() {
  group('ProductsAPIService', () {
    ProductsAPIService productsAPIService = ProductsAPIService();
    BPProduct? product;
    test('addProduct should add a new product', () async {
      String productName = 'Test Product';
      var response = await productsAPIService.addProduct(
        name: productName,
        price: 1.0,
        category: APIService.data.categories[0],
        status: ProductStatus.Available,
      );
      product = response.Result;
      expect(response.isSuccess, true);
      expect(
          APIService.data.products.where((x) => x.Name == productName).length,
          greaterThan(1));
    });

    test('getProducts should return a list of products', () async {
      var response = await productsAPIService.getProducts();
      expect(response.isSuccess, true);
      expect(APIService.data.products.length, greaterThan(0));
    });

    test('updateProduct should update an existing product', () async {
      String productName = 'Updated Test Product';
      product = APIService.data.products[0];
      var response = await productsAPIService.updateProduct(
          product!.ID,
          productName,
          1.0,
          ProductStatus.Available,
          APIService.data.categories[0],
          null,
          null,
          null);
      expect(response.isSuccess, true);
      expect(APIService.data.products[0].Name, productName);
    });

    test('deleteProduct should delete an existing product', () async {
      var id = product!.ID;
      var response = await productsAPIService.deleteProduct(product!);
      expect(response.isSuccess, true);
      expect(
          APIService.data.products.where((x) => x.ID == id).length, equals(0));
    });
  });
}
