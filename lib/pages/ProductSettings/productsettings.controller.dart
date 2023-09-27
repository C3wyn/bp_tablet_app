import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/pages/ProductSettings/CategoryChips/CategoryChipList.widget.dart';
import 'package:bp_tablet_app/pages/ProductSettings/ExtrasChips/ExtrasChipList.widget.dart';
import 'package:bp_tablet_app/pages/ProductSettings/IngredientsChips/IngredientsChipList.widget.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.page.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:flutter/material.dart';

import '../../models/productstatus.enum.dart';
import '../../services/APIService/Models/apiresponse.model.dart';

class ProductSettingsPageController {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  BPProduct? product;

  final TextEditingController nameTIController = TextEditingController();

  final TextEditingController descriptionTIController = TextEditingController();

  final TextEditingController priceTIController = TextEditingController();

  ProductStatus selectedStatus = ProductStatus.Available;

  late IngredientsChips ingredientsChipWidget;
  late CategoryChipList categoryChipWidget;
  late ExtrasChips extraChipWidget;

  Map<BPIngredient, bool> selectedIngredients = {};
  Map<BPExtra, bool> selectedExtras = {};

  ProductSettingsPageController({this.product}) {
    for(BPIngredient ingredient in APIService.data.ingredients){
      selectedIngredients[ingredient] = false;
    }

    if(product!=null){
      nameTIController.text = product!.Name;
      priceTIController.text = product!.Price.toString();
      descriptionTIController.text = product!.Description;
      selectedStatus = product!.Status;
      
      for(BPIngredient ingredient in product!.Ingredients){
        selectedIngredients[ingredient] = true;
      }
      for(BPExtra extra in product!.Extras){
        selectedExtras[extra] = true;
      }
    }
    ingredientsChipWidget = IngredientsChips(selectedIngredients: selectedIngredients); 
    categoryChipWidget = CategoryChipList(selectedCategory: product?.Category);
    extraChipWidget = ExtrasChips(selectedExtras: selectedExtras);
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

    void _onSave(BuildContext context) async {
    APIResponse response;
    List<int> ingredientsIDs = [];
    for(BPIngredient key in selectedIngredients.keys){
      if(selectedIngredients[key]!) ingredientsIDs.add(key.ID);
    }
    List<int> extrasIDs = [];
    for(BPExtra key in selectedExtras.keys){
      if(selectedExtras[key]!) extrasIDs.add(key.ID);
    }
    if(product==null){
      response = await APIService.addProduct(
        name: nameTIController.text, 
        price: double.parse((priceTIController.text).substring(0,priceTIController.text.length-1).replaceAll(",", ".")), 
        category: categoryChipWidget.selectedCategory!, 
        status: selectedStatus,
        description: descriptionTIController.text,
        ingredients: ingredientsIDs,
        extras: extrasIDs
      );
    }else{
       response = await APIService.updateProduct(
        id: product!.ID,
        name: nameTIController.text, 
        price: double.parse((priceTIController.text).substring(0,priceTIController.text.length-1).replaceAll(",", ".")), 
        category: categoryChipWidget.selectedCategory!, 
        status: selectedStatus,
        description: descriptionTIController.text,
        ingredients: ingredientsIDs,
        extras: extrasIDs
      );
    }
    
    if(response.isSuccess) Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.Message))
    );
  }



  void onSave(BuildContext context) async {
    APIResponse response;

    List<int> ingredientsIDs = [];
    for(BPIngredient key in selectedIngredients.keys){
      if(selectedIngredients[key]!) ingredientsIDs.add(key.ID);
    }
    List<int> extrasIDs = [];
    for(BPExtra key in selectedExtras.keys){
      if(selectedExtras[key]!) extrasIDs.add(key.ID);
    }
    if(product==null){
      response = await APIService.addProduct(
        name: nameTIController.text, 
        price: double.parse((priceTIController.text).substring(0,priceTIController.text.length-1).replaceAll(",", ".")), 
        category: categoryChipWidget.selectedCategory!, 
        status: selectedStatus,
        description: descriptionTIController.text,
        ingredients: ingredientsIDs,
        extras: extrasIDs
      );
    }else{
       response = await APIService.updateProduct(
        id: product!.ID,
        name: nameTIController.text, 
        price: double.parse((priceTIController.text).substring(0,priceTIController.text.length-1).replaceAll(",", ".")), 
        category: categoryChipWidget.selectedCategory!, 
        status: selectedStatus,
        description: descriptionTIController.text,
        ingredients: ingredientsIDs,
        extras: extrasIDs
      );
    }
    
    if(response.isSuccess) Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.Message))
    );
  }
}