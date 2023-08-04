import 'package:bp_tablet_app/dialogs/IngredientsDialog/EditIngredients.dialog.dart';
import 'package:bp_tablet_app/dialogs/OptionsDialog/options.dialog.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/pages/ProductSettings/IngredientsChips/DeleteIngredientDialog/DeleteIngredient.dialog.dart';
import 'package:flutter/material.dart';

import '../../../services/APIService/APIService.dart';
import '../../../services/APIService/Models/apiresponse.model.dart';

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

  void onAddIngredientClick(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (builder) => const EditIngredientsDialog()
    );
    setState(() {
      widget.selectedIngredients;
    });
  }

  void _onChipHold(BuildContext context, BPIngredient ingredient) {
    showModalBottomSheet(context: context, builder: (BuildContext con) {
      return OptionsDialog<BPIngredient>(
        context: context,
        model: ingredient,
        onEditClicked: (con, ing) => optionsOnEditSelect(context, ingredient),
        onDeleteClicked: (con, ing) => optionsOnDeleteSelect(con, ing),
      );
    });
  }
  
  void optionsOnEditSelect(BuildContext context, BPIngredient ingredient) async {
    Navigator.of(context).pop();
    await _onSelectedChipTap(context, ingredient);
    setState(() {
      ingredient;
    });
  }

  void optionsOnDeleteSelect(BuildContext context, BPIngredient ingredient) async {
    Navigator.of(context).pop();
    await _onDeleteIngredient(context, ingredient);
    setState(() {
      widget.selectedIngredients;
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
  
  _onDeleteIngredient(BuildContext context, BPIngredient ingredient) {
    return showDialog(
      context: context,
      builder: (builder) {
        return DeleteIngredientDialog(ingredient: ingredient);
      }
    );
  }
}