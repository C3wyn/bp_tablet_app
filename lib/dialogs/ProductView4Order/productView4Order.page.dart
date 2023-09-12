import 'package:bp_tablet_app/dialogs/ChooseDeliveryType/ChooseDeliveryType.dialog.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/services/CartService/Cart.service.dart';
import 'package:flutter/material.dart';

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
            child: const Text('Abbrechen'),
            onPressed: () => _onAbortClicked(context),
            ),
            OutlinedButton(onPressed: () => _onAddMoreClicked(context), child: const Text('Weitere Hinzufügen')),
            ElevatedButton(onPressed: () => _onSendProductClicked(context), child: const Text('Hinzufügen'))
          ],
        )
      ],
      title: Text(widget.product.Name, style: Theme.of(context).textTheme.headlineMedium),
      content: SizedBox(
        height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(
          builder: (builder, constraints) {
            return SizedBox(
              height: constraints.maxHeight,width: constraints.maxWidth,
              child: Row(
                children: [
                  SizedBox(
                    height: constraints.maxHeight, width: constraints.maxWidth/2,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Zutaten', style: Theme.of(context).textTheme.headlineSmall),
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
                  SizedBox(
                    height: constraints.maxHeight, width: constraints.maxWidth/2,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Extras', style: Theme.of(context).textTheme.headlineSmall),
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
        title: Text('Extra'),
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
  
  _onSendProductClicked(BuildContext context) {
    CartService.addProduct(widget.product, widget.selectedIngredients, widget.selectedExtras);
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) => ChooseDeliveryTypeDialog()
    );
  }
}