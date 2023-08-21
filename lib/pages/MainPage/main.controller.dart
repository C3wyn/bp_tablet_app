import 'package:bp_tablet_app/dialogs/OptionsDialog/options.dialog.dart';
import 'package:bp_tablet_app/dialogs/ProductView4Order/productView4Order.page.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.page.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:flutter/material.dart';

class BPMainPageController {

  List<BPProduct> _products = [];
  List<BPProduct> get Products => _products;
  bool pageIsBusy = false;

  Future<BPMainPageController> gatherData(BuildContext context) async {
    pageIsBusy = true;
    var responseIngredients = await APIService.getIngredients();
    var responseCategories = await APIService.getCategories();
    var responseProducts = await APIService.getProducts();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseProducts.Message))
      );
    if(responseCategories.isSuccess && responseIngredients.isSuccess && responseProducts.isSuccess){
      _products = APIService.data.products;
      pageIsBusy = false;
      return BPMainPageController();
    }else{
      await Future.delayed(Duration(seconds: 30));
      return gatherData(context);
    }
  }

  void onProductClick(context, product) async {
    await showDialog<void>(
      builder: (BuildContext context) { 
        return ProductView4Order(product: product);
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