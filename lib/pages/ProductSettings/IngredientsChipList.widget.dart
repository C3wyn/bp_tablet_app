import 'package:bp_tablet_app/dialogs/IngredientsDialog/EditIngredients.dialog.dart';
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
        InkWell(
          onLongPress: () => _onChipHold(context, ingredient),
          child: FilterChip(
          selected: widget.selectedIngredients[ingredient]?? false,
          label: Text(ingredient.Name),
          onSelected: (selected) => _onChipSelect(context, ingredient, selected),
          ),
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
          TextButton(child: Text('Abbrechen'), onPressed: Navigator.of(context).pop),
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

  void _onChipHold(BuildContext context, BPIngredient ingredient) {
    showModalBottomSheet(context: context, builder: (BuildContext con) {
      return ListView(
        shrinkWrap: true,
        children: [
          InkWell(
            child: const ListTile(
              leading: Icon(Icons.edit),
              title: Text('Bearbeiten')
            ),
            onTap: () async {
              Navigator.of(context).pop();
              await _onSelectedChipTap(context, ingredient);
              setState(() {
                ingredient;
              });
            },
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Löschen')
            ),
          ),
        ],
      );
    });
  }
  
  _onChipSelect(BuildContext context, BPIngredient ingredient, bool selected) {
    setState(() {
      widget.selectedIngredients[ingredient] = selected;
    });
  }
  
  _onSelectedChipTap(BuildContext context, BPIngredient? ingredient) async {
    return await showDialog(context: context, builder: (builder) {
      return EditIngredientsDialog(ingredient: ingredient);
    });
  }
}