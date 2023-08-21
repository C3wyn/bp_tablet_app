import 'package:bp_tablet_app/dialogs/ChooseDeliveryType/ChooseDeliveryType.dialog.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/models/product.model.dart';
import 'package:bp_tablet_app/services/CartService/Cart.service.dart';
import 'package:flutter/material.dart';

class ProductView4Order extends StatefulWidget {

  BPProduct product;
  Map<BPIngredient, bool> selectedIngredients = {};

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
      title: Text(widget.product.Name),
      content: Column(
        children: [
          const Text('Zutaten'),
          SizedBox(
            height: 300,width: MediaQuery.of(context).size.width,
            child: _generateIngredientsList(),
          )
        ],
      ),
    );
  }

  ListView _generateIngredientsList() {
    return ListView.builder(
      itemCount: widget.product.Ingredients.length,
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
  
  _onAbortClicked(BuildContext context) {
    Navigator.of(context).pop();
  }
  
  _onAddMoreClicked(BuildContext context) {
    CartService.addProduct(widget.product, widget.selectedIngredients);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produkt zur Bestellung hinzugefügt.'))
    );
  }
  
  _onSendProductClicked(BuildContext context) {
    CartService.addProduct(widget.product, widget.selectedIngredients);
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) => ChooseDeliveryTypeDialog()
    );
  }
}