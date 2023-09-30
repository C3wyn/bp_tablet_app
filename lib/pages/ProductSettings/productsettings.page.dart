import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/pages/ProductSettings/IngredientsChips/IngredientsChipList.widget.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.controller.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
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
          title: Text(widget.product == null
              ? 'Produkt hinzufügen'
              : '${widget.product?.Name} bearbeiten'),
          actions: [
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Speichern'),
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.onSave(context);
                }
              },
              style: Theme.of(context).elevatedButtonTheme.style,
            )
          ],
        ),
        body: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Produktinformationen',
                    style: Theme.of(context).textTheme.displayMedium),
                //Namen Text Feld
                TextFormField(
                  controller: controller.nameTIController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle:
                        Theme.of(context).inputDecorationTheme.labelStyle,
                    border: const OutlineInputBorder(),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                  validator: (value) =>
                      value!.isEmpty ? 'Bitte geben Sie einen Namen ein' : null,
                ),
                const SizedBox(height: 10),

                //Beschreibung Text Feld
                TextFormField(
                    controller: controller.descriptionTIController,
                    decoration: InputDecoration(
                        labelText: 'Beschreibung',
                        labelStyle:
                            Theme.of(context).inputDecorationTheme.labelStyle,
                        border: const OutlineInputBorder()),
                    style: Theme.of(context).textTheme.bodyLarge,
                    minLines: 1,
                    maxLines: 5),
                const SizedBox(height: 10),
                //Preis Text Feld
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: controller.priceTIController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Preis'),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[,.]{0,1}[0-9]{0,2}')),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll('.', ',') + "€",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                //Status Dropdown
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Status'),
                  value: controller.selectedStatus,
                  items: controller.generateStatusList(),
                  onChanged: (ProductStatus? value) {
                    controller.selectedStatus = value!;
                  },
                  validator: (value) => value == ProductStatus.None
                      ? 'Bitte wählen Sie einen Status aus'
                      : null,
                ),

                const SizedBox(height: 50),
                Text('Kategorie auswählen',
                    style: Theme.of(context).textTheme.displayMedium),
                FormField(
                  builder: (field) => controller.categoryChipWidget,
                  //validator: (value) => controller.categoryChipWidget.selectedCategory==null ? 'Bitte wählen Sie eine Kategorie aus' : null,
                ),
                const SizedBox(height: 50),
                Text('Zutaten auswählen',
                    style: Theme.of(context).textTheme.displayMedium),
                FormField(
                  builder: (FormFieldState<dynamic> field) =>
                      controller.ingredientsChipWidget,
                ),
                const SizedBox(height: 50),
                Text('Extras auswählen',
                    style: Theme.of(context).textTheme.displayMedium),
                controller.extraChipWidget
              ],
            ),
          )),
        ));
  }
}
