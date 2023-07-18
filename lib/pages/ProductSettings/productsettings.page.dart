import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/productstatus.enum.dart';

class ProductSettingsPage extends StatefulWidget {
  const ProductSettingsPage({super.key});

  @override
  State<ProductSettingsPage> createState() => _ProductSettingsPageState();
}

class _ProductSettingsPageState extends State<ProductSettingsPage> {

  ProductSettingsPageController controller = ProductSettingsPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produkt hinzufügen')
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
                items: controller.generateStatusList(), 
                onChanged: (Object? value) {  },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: controller.getCategories(),
                builder: (builder, snapshot) =>  controller.generateCategoryList(builder, snapshot)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: controller.getIngredients(),
                builder: (builder, snapshot) =>  generateIngredientsList(builder, snapshot, setState)
              ),
            )
          ],
          
        )
      )
    );
  }

  Widget generateIngredientsList(BuildContext builder, AsyncSnapshot<List<BPIngredient>> snapshot, Function setState) {
    if(!snapshot.hasData) return const CircularProgressIndicator();
    List<Widget> result = [];
    controller.ingredients = {};
    
    for(BPIngredient ingredient in snapshot.data!){
      result.add(
        FilterChip(
        selected: /*controller.ingredients[ingredient]!*/ true,
        label: Text(ingredient.Name),
        onSelected: (bool selected) {
          setState(() {
            controller.ingredients.update(ingredient, (value) => selected);
            print(controller.ingredients);
          });
        },
      )
      );
    }
    result.add(
      InputChip(
        label: const Icon(Icons.add),
        onPressed: () {},
      )
    );

    return Wrap(
      spacing: 5.0,
      children: result
    );
  }
}