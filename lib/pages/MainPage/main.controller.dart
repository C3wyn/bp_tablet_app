import 'package:bp_tablet_app/dialogs/ChooseDeliveryType/ChooseDeliveryType.dialog.dart';
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

  Future<BPMainPageController> gatherData(BuildContext context) async {
    if(_products.isEmpty){
      var responseIngredients = await APIService.getIngredients();
      var responseCategories = await APIService.getCategories();
      var responseProducts = await APIService.getProducts();
      var responseExtras = await APIService.getExtras();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseProducts.Message))
        );
      if(responseCategories.isSuccess && responseIngredients.isSuccess && responseProducts.isSuccess && responseExtras.isSuccess){
        _products = APIService.data.products;
        return BPMainPageController();
      }else{
        await Future.delayed(const Duration(seconds: 30));
        return gatherData(context);
      }
    }
    return BPMainPageController();
  }

  Future onProductClick(context, product) async {
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

  onSendOrderClicked(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const ChooseDeliveryTypeDialog()
    );
  }
}