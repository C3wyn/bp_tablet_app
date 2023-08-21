import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/pages/ProductSettings/CategoryChips/CategoryChipList.widget.dart';
import 'package:bp_tablet_app/pages/ProductSettings/IngredientsChips/IngredientsChipList.widget.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.page.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:flutter/material.dart';

import '../../models/productstatus.enum.dart';
import '../../services/APIService/Models/apiresponse.model.dart';

class ProductSettingsPageController {

  BPProduct? product;

  final TextEditingController nameTIController = TextEditingController();

  final TextEditingController descriptionTIController = TextEditingController();

  final TextEditingController priceTIController = TextEditingController();

  ProductStatus selectedStatus = ProductStatus.None;

  late IngredientsChips ingredientsChipWidget;
  late CategoryChipList categoryChipWidget;

  Map<BPIngredient, bool> selectedIngredients = {};

  ProductSettingsPageController({this.product}) {
    for(BPIngredient ingredient in APIService.data.ingredients){
      selectedIngredients[ingredient] = product?.Ingredients.firstWhere((x) => x.ID==ingredient.ID)!=null? true:false;
    }

    if(product!=null){
      nameTIController.text = product!.Name;
      priceTIController.text = product!.Price.toString();
      descriptionTIController.text = product!.Description;
      selectedStatus = product!.Status;
      
      for(BPIngredient ingredient in product!.Ingredients){
        selectedIngredients[ingredient] = true;
      }
    }
    ingredientsChipWidget = IngredientsChips(selectedIngredients: selectedIngredients); 
    categoryChipWidget = CategoryChipList(selectedCategory: product?.Category);
  }

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
          child: Text(valueFriendlyName),
          onTap: () => selectedStatus = value,
        )
      );
    }
    return menuItems;
  }

  Future<APIResponse<List<BPCategory>?>> getCategories() => APIService.getCategories();

  Future<APIResponse<List<BPIngredient>?>> getIngredients() => APIService.getIngredients();

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

  void onSave(BuildContext context) async {
    APIResponse response;

    List<int> ingredientsIDs = [];
    for(BPIngredient key in selectedIngredients.keys){
      if(selectedIngredients[key]!) ingredientsIDs.add(key.ID);
    }

    response = await APIService.addProduct(
      name: nameTIController.text, 
      price: double.parse((priceTIController.text).substring(0,priceTIController.text.length-1).replaceAll(",", ".")), 
      category: categoryChipWidget.selectedCategory!, 
      status: selectedStatus,
      description: descriptionTIController.text,
      ingredients: ingredientsIDs
    );
    
    if(response.isSuccess) Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.Message))
    );
  }
}