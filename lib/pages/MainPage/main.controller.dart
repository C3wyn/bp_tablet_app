import 'package:bp_tablet_app/dialogs/ChooseDeliveryType/ChooseDeliveryType.dialog.dart';
import 'package:bp_tablet_app/dialogs/DeleteDialog/delete.dialog.dart';
import 'package:bp_tablet_app/dialogs/OptionsDialog/options.dialog.dart';
import 'package:bp_tablet_app/dialogs/ProductView4Order/ProductView4OrderResult.enum.dart';
import 'package:bp_tablet_app/dialogs/ProductView4Order/productView4Order.page.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.page.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:flutter/material.dart';

class BPMainPageController {
  List<BPProduct> _products = [];
  List<BPProduct> get Products => _products;

  Future<BPMainPageController> gatherData(
      BuildContext context, Function setState) async {
    setState = setState;
    if (_products.isEmpty) {
      var responseIngredients = await APIService.getIngredients();
      var responseCategories = await APIService.getCategories();
      var responseExtras = await APIService.getExtras();
      var responseProducts = await APIService.getProducts();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(responseProducts.Message)));

      if (!responseProducts.isSuccess) {
        await Future.delayed(const Duration(seconds: 30));
        return gatherData(context, setState);
      }
      _products = APIService.data.products;
      return BPMainPageController();
    }
    return BPMainPageController();
  }

  Future onProductClick(context, product) async {
    OrderResult? res = await showDialog<OrderResult>(
        builder: (BuildContext context) {
          return ProductView4Order(product: product);
        },
        context: context);
    if (res == OrderResult.Send) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => const ChooseDeliveryTypeDialog());
    }
  }

  onSettingsClicked(BuildContext context) {
    Navigator.of(context).pushNamed('/product');
  }

  onProductLongPress(
      BuildContext context, BPProduct product, Function setState) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return OptionsDialog<BPProduct>(
            model: product,
            context: context,
            onEditClicked: (con, prod) => _onEditClicked(con, prod),
            onSelectClicked: (con, prod) => _onSelectClicked(con, prod),
            onDeleteClicked: (con, prod) =>
                _onDeleteClicked(con, prod, setState),
          );
        });
  }

  _onEditClicked(BuildContext context, BPProduct product) async {
    Navigator.of(context).pop();
    await showDialog(
        context: context,
        builder: (builder) {
          return ProductSettingsPage(product: product);
        });
  }

  onSendOrderClicked(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => const ChooseDeliveryTypeDialog());
  }

  _onSelectClicked(BuildContext con, BPProduct prod) {
    Navigator.of(con).pop();
    onProductClick(con, prod);
  }

  _onDeleteClicked(BuildContext con, BPProduct prod, Function setState) async {
    Navigator.of(con).pop();
    await showDialog(
        context: con,
        builder: (_) => BPDeleteDialog(
            message:
                'Möchtest du das Produkt ${prod.Name}(ID: ${prod.ID}) unwiederruflich löschen?',
            title: 'Produkt löschen',
            onDeletePressed: () => _deleteProduct(prod, con, setState)));
  }

  _deleteProduct(
      BPProduct product, BuildContext context, Function setState) async {
    APIResponse response = await APIService.deleteProduct(product);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.Message)));
    if (response.isSuccess) {
      Navigator.of(context).pop();
      setState(() {
        _products = APIService.data.products;
      });
    }
  }
}
