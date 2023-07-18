import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.page.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:flutter/material.dart';

import '../../models/productstatus.enum.dart';

class ProductSettingsPageController {
  final TextEditingController nameTIController = TextEditingController();

  final TextEditingController descriptionTIController = TextEditingController();

  final TextEditingController priceTIController = TextEditingController();

  final  statusTIController = TextEditingController();

  Map<BPIngredient, bool> ingredients = {};

  List<DropdownMenuItem<ProductStatus>> generateStatusList() {

    List<DropdownMenuItem<ProductStatus>> menuItems = [];

    for(ProductStatus value in ProductStatus.values){
      String valueFriendlyName = "";
      switch(value) {
        case ProductStatus.Archived: valueFriendlyName = "Archiviert";
        case ProductStatus.Available: valueFriendlyName = "Verfügbar";
        case ProductStatus.SoldOut: valueFriendlyName = "Ausverkauft";
        default: valueFriendlyName = "Keinen";
      }

      menuItems.add(
        DropdownMenuItem(
          value: value,
          child: Text(valueFriendlyName)
        )
      );
    }
    return menuItems;
  }

  Future<List<BPCategory>> getCategories() => APIService.getCategories();

  Future<List<BPIngredient>> getIngredients() => APIService.getIngredients();

  Widget generateCategoryList(BuildContext context, AsyncSnapshot<List<BPCategory>> snapshot) {
    if(!snapshot.hasData) return const CircularProgressIndicator(); 
    List<DropdownMenuItem<BPCategory>> items = [];
    for(BPCategory category in snapshot.data!){
      items.add(
        DropdownMenuItem(
          value: category,
          child: Text(category.Name)
        )
      );
    }

    return DropdownButtonFormField(
      items: items, 
      onChanged: (value) {},
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Kategorie'
      ),
    );
  }
}