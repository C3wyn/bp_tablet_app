import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/pages/ProductSettings/IngredientsChips/IngredientsChipList.widget.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/productstatus.enum.dart';

class ProductSettingsPage extends StatefulWidget {

  BPProduct? product;

  ProductSettingsPage({super.key, this.product});

  @override
  State<ProductSettingsPage> createState() => ProductSettingsPageState();
}

class ProductSettingsPageState extends State<ProductSettingsPage> {
  late ProductSettingsPageController controller;

  @override
  Widget build(BuildContext context) {
    controller = ProductSettingsPageController(product: widget.product);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produkt hinzufügen'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => controller.onSave(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller.nameTIController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller.descriptionTIController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Beschreibung'
                ),
                minLines: 1,
                maxLines: 5
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: controller.priceTIController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Preis'
                ),
                inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]{0,2}')),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll('.', ',') + "€",
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Status'
                ), 
                value: controller.selectedStatus,
                items: controller.generateStatusList(), 
                onChanged: (ProductStatus? value) { controller.selectedStatus=value!; },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: controller.categoryChipWidget
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: controller.ingredientsChipWidget
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: controller.extraChipWidget
            )
          ],
        )
      )
    );
  }
}