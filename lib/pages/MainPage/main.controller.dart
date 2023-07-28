import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
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

  BPMainPageController() {
    APIService.getIngredients();
    APIService.getCategories();
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

  onProductLongPress(BuildContext context, BPProduct product) {
    showModalBottomSheet(context: context, builder: (builder) {
      return Column(children: [
        ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: Icon(Icons.open_in_browser),
              title: Text('Öffnen'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Bearbeiten'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Löschen'),
              onTap: () {},
            )
          ],
        )
      ],);
    });
  }
}