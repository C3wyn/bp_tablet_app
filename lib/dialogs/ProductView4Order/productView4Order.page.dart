import 'package:bp_tablet_app/dialogs/ChooseDeliveryType/ChooseDeliveryType.dialog.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/services/CartService/Cart.service.dart';
import 'package:flutter/material.dart';

import 'ProductView4OrderResult.enum.dart';

class ProductView4Order extends StatefulWidget {

  BPProduct product;
  Map<BPIngredient, bool> selectedIngredients = {};
  Map<BPExtra, bool> selectedExtras = {}; 

  ProductView4Order({super.key, required this.product});

  @override
  State<ProductView4Order> createState() => _ProductView4OrderState();
}

class _ProductView4OrderState extends State<ProductView4Order> {

  @override
  void initState() {
    super.initState();
    for(BPIngredient ingredient in widget.product.Ingredients){
      widget.selectedIngredients[ingredient] = true;
    }
    for(BPExtra extra in widget.product.Extras){
      widget.selectedExtras[extra] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
            child: Text('Abbrechen'),
            onPressed: () => _onAbortClicked(context),
            ),
            OutlinedButton(onPressed: () => _onAddMoreClicked(context), child: Text('Weitere Hinzufügen', style: Theme.of(context).textTheme.titleMedium)),
            ElevatedButton.icon(icon: const Icon(Icons.shopping_cart), onPressed: () => _onSendProductClicked(context), style: Theme.of(context).elevatedButtonTheme.style, label: const Text('Bestellen'))
          ],
        )
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.product.Name, style: Theme.of(context).textTheme.displayMedium),
          IconButton(
            icon: const Icon(Icons.cancel_outlined),
            onPressed: () => Navigator.of(context).pop(),
            iconSize: 32,
          )
        ],
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(
          builder: (builder, constraints) {
            return SizedBox(
              height: constraints.maxHeight,width: constraints.maxWidth,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    height: constraints.maxHeight, width: constraints.maxWidth/2,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Zutaten', style: Theme.of(context).textTheme.displayMedium),
                          const Divider(),
                          SingleChildScrollView(
                            child: SizedBox(
                              height: constraints.maxHeight,width: constraints.maxWidth/2,
                              child: _generateIngredientsList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    height: constraints.maxHeight, width: constraints.maxWidth/2,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Extras', style: Theme.of(context).textTheme.displayMedium),
                          SingleChildScrollView(
                            child: SizedBox(
                              height: constraints.maxHeight,width: constraints.maxWidth/2,
                              child: _generateExtrasList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          
        ),
      ),
    );
  }

  ListView _generateIngredientsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.product.Ingredients.length,
      physics: const NeverScrollableScrollPhysics(),
      prototypeItem: ListTile(
        title: const Text('Zutat'),
        leading: Switch(
          value: true,
          onChanged: (value) => null,
        )
      ),
      itemBuilder: (builder, index) {
        BPIngredient ingredient = widget.product.Ingredients[index];
        return ListTile(
          title: Text(widget.product.Ingredients[index].Name),
          leading: Switch(
            value: widget.selectedIngredients[ingredient]!,
            onChanged: (value) => setState(() {
              widget.selectedIngredients[ingredient] = value;
            }),
          )
        );
      }
    );
  }

  ListView _generateExtrasList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.product.Extras.length,
      prototypeItem: ListTile(
        title: const Text('Extra'),
        leading: Switch(
          value: false,
          onChanged: (value) => null,
        )
      ),
      itemBuilder: (builder, index) {
        BPExtra extra = widget.product.Extras[index];
        return ListTile(
          title: Text(widget.product.Extras[index].Name),
          leading: Switch(
            value: widget.selectedExtras[extra]!,
            onChanged: (value) => setState(() {
              widget.selectedExtras[extra] = value;
            }),
          )
        );
      }
    );
  }
  
  _onAbortClicked(BuildContext context) {
    Navigator.of(context).pop();
  }
  
  _onAddMoreClicked(BuildContext context) {
    CartService.addProduct(widget.product, widget.selectedIngredients, widget.selectedExtras);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produkt zur Bestellung hinzugefügt.'))
    );
  }
  
  _onSendProductClicked(BuildContext context)async  {
    CartService.addProduct(widget.product, widget.selectedIngredients, widget.selectedExtras);
    Navigator.of(context).pop(OrderResult.Send);
    
  }
}