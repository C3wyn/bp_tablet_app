import 'package:bp_tablet_app/models/product.model.dart';
import 'package:flutter/material.dart';
class AddProductDialog {
  static Widget createAddProductDialog(BuildContext context, BPProduct product) {
    return AlertDialog(
      title: Text(product.Name),
      content: Column(
        children: [
          const Text('Zutaten'),
          const Divider(),
          Expanded(child: createIngredientsList(context, product)),
          const Divider()
        ],
      ),
      actions: [
        TextButton(child: Text('Abbrechen'), onPressed: () {},),
        ElevatedButton(
          onPressed: () {}, 
          child: const Text('Bestellen')
        ),
        
      ],
    );
  }

  static Widget createIngredientsList(BuildContext con, BPProduct product) {
    return Container(
      height: 300,
      width: 300,
      child: ListView.builder(
        itemCount: product.Ingredients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(product.Ingredients[index].Name),
            trailing: Switch(
              onChanged: (bool? value) {},
              value: true
            )
          );
        },
    
      ),
    );
  }
}
