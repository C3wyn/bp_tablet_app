import 'package:bp_tablet_app/dialogs/OptionsDialog/options.dialog.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.page.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:flutter/material.dart';

import '../../dialogs/AddProduct/addproduct.dialog.dart';

class BPMainPageController {

  List<BPProduct> _products = [];
  List<BPProduct> get Products => _products;

  BPMainPageController() {
    APIService.getIngredients();
    APIService.getCategories();
  }

  Future<BPMainPageController> gatherData() async {
    await APIService.getIngredients();
    await APIService.getCategories();
    await APIService.getProducts();
    _products = APIService.data.products;
    return BPMainPageController();
  }

  void onProductClick(context, product) {
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
      return OptionsDialog<BPProduct>(
        model: product, 
        context: context, 
        onEditClicked: (con, prod) => _onEditClicked(con, prod)
      );
    });
  }

  _onEditClicked(BuildContext context, BPProduct product) async {
    Navigator.of(context).pop();
    await showDialog(context: context, builder: (builder) {
        return ProductSettingsPage(product: product);
    });
  }
}