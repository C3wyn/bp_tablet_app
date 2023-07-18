import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:flutter/material.dart';

import '../../dialogs/AddProduct/addproduct.dialog.dart';

class BPMainPageController {

  final List<BPProduct> _products = <BPProduct>[
    BPProduct('test-id-1', 'Test Product 1', ingredients: [BPIngredient(1, 'Zutat 1')]),
    BPProduct('test-id-2', 'Test Product 2'),
    BPProduct('test-id-1', 'Test Product 1'),
    BPProduct('test-id-2', 'Test Product 2'),
    BPProduct('test-id-1', 'Test Product 1'),
    BPProduct('test-id-2', 'Test Product 2'),
    BPProduct('test-id-1', 'Test Product 1'),
    BPProduct('test-id-2', 'Test Product 2'),
    BPProduct('test-id-1', 'Test Product 1'),
    BPProduct('test-id-2', 'Test Product 2')
  ];

  List<BPProduct> get Products => _products;

  List<BPProduct> getProducts() {
    return _products;
  }

  void onProductClick(context, product) {
    print(product.Ingredients);
    showDialog<void>(
      builder: (BuildContext context) { 
        return AddProductDialog.createAddProductDialog(context, product);
       }, 
      context: context
    );
  }

  onSettingsClicked(BuildContext context) {
    Navigator.of(context).pushNamed('/product');
  }
}