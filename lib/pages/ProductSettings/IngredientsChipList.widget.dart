import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:flutter/material.dart';

import '../../services/APIService/APIService.dart';
import '../../services/APIService/Models/apiresponse.model.dart';

class IngredientsChips extends StatefulWidget {

  final Map<BPIngredient, bool> selectedIngredients;

  const IngredientsChips({required Map<BPIngredient, bool> this.selectedIngredients, super.key});

  @override
  State<IngredientsChips> createState() => _IngredientsChipsState();
}

class _IngredientsChipsState extends State<IngredientsChips> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Initialisiere die selectedIngredients mit allen Zutaten auf false
    for (BPIngredient ingredient in APIService.data.ingredients) {
      widget.selectedIngredients[ingredient] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> result = [];
    
    for(BPIngredient ingredient in APIService.data.ingredients){
      result.add(
        FilterChip(
        selected: widget.selectedIngredients[ingredient]?? false,
        label: Text(ingredient.Name),
        onSelected: (bool selected) {
          setState(() {
            widget.selectedIngredients[ingredient] = selected;
          });
        },
      )
      );
    }
    
    result.add(
      InputChip(
        label: const Icon(Icons.add),
        onPressed: () => onAddIngredientClick(context)
      )
    );
    
    return Wrap(
      spacing: 5.0,
      children: result
    );
  }

  void onAddIngredientClick(BuildContext context) {
    showDialog(context: context, builder: (builder){
      TextEditingController controller = TextEditingController();
      return AlertDialog(
        title: Text('Zutat hinzufügen'),
        content: Form(
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name'
            ),
          )
        ),
        actions: [
          TextButton(child: const Text('Abbrechen'), onPressed: Navigator.of(context).pop),
          ElevatedButton(onPressed: (){
            _createIngredient(controller.text, context);
          }, child: const Text('Hinzufügen'))
        ],
      );
    });
  }

  void _createIngredient(String name, BuildContext context) async {
    APIResponse response = await APIService.addIngredient(name);
    setState(() {
      widget.selectedIngredients;
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.Message),
      )
    );
  }
}