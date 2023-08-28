import 'package:bp_tablet_app/dialogs/DeleteDialog/delete.dialog.dart';
import 'package:bp_tablet_app/dialogs/ExtrasDialog/EditExtras.dialog.dart';
import 'package:bp_tablet_app/dialogs/IngredientsDialog/EditIngredients.dialog.dart';
import 'package:bp_tablet_app/dialogs/OptionsDialog/options.dialog.dart';
import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/pages/ProductSettings/IngredientsChips/DeleteIngredientDialog/DeleteIngredient.dialog.dart';
import 'package:flutter/material.dart';

import '../../../services/APIService/APIService.dart';
import '../../../services/APIService/Models/apiresponse.model.dart';

class ExtrasChips extends StatefulWidget {

  final Map<BPExtra, bool> selectedExtras;

  const ExtrasChips({required this.selectedExtras, super.key});

  @override
  State<ExtrasChips> createState() => _ExtrasChipsState();
}

class _ExtrasChipsState extends State<ExtrasChips> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> result = [];
    
    for(BPExtra extra in APIService.data.extras){
      result.add(
        InkWell(
          onLongPress: () => _onChipHold(context, extra),
          child: FilterChip(
          selected: widget.selectedExtras[extra]?? false,
          label: Text(extra.Name),
          onSelected: (selected) => _onChipSelect(context, extra, selected),
          ),
        )
      );
    }
    
    result.add(
      InputChip(
        label: const Icon(Icons.add),
        onPressed: () => onAddExtraClick(context)
      )
    );
    
    return Wrap(
      spacing: 5.0,
      children: result
    );
  }

  void onAddExtraClick(BuildContext context) async {
    
    await showDialog(
      context: context,
      builder: (builder) => const EditExtrasDialog()
    );
    
    setState(() {
      widget.selectedExtras;
    });
  }

  void _onChipHold(BuildContext context, BPExtra extra) {
    showModalBottomSheet(context: context, builder: (BuildContext con) {
      return OptionsDialog<BPExtra>(
        context: context,
        model: extra,
        onEditClicked: (con, ext) => optionsOnEditSelect(context, ext),
        onDeleteClicked: (con, ext) => optionsOnDeleteSelect(con, ext),
      );
    });
  }
  
  void optionsOnEditSelect(BuildContext context, BPExtra extra) async {
    Navigator.of(context).pop();
    await _onSelectedChipTap(context, extra);
    setState(() {
      extra;
    });
  }

  void optionsOnDeleteSelect(BuildContext context, BPExtra extra) async {
    Navigator.of(context).pop();
    await _onDeleteExtra(context, extra);
    setState(() {
      widget.selectedExtras;
    });
  }

  _onChipSelect(BuildContext context, BPExtra extra, bool selected) {
    setState(() {
      widget.selectedExtras[extra] = selected;
    });
  }
  
  _onSelectedChipTap(BuildContext context, BPExtra? extra) async {
    
    return await showDialog(context: context, builder: (builder) {
      return EditExtrasDialog(extra: extra);
    });
    
  }
  
  _onDeleteExtra(BuildContext context, BPExtra extra) async {
    await showDialog(context: context, builder: (_) => BPDeleteDialog(
      message: 'Möchtest du das Extra ${extra.Name}(ID: ${extra.ID}) unwiederruflich löschen?', 
      title: 'Kategorie löschen', 
      onDeletePressed: () async => await deleteExtra(extra)
      )
    );
  }
  
  deleteExtra(BPExtra extra) async {
    APIResponse response = await APIService.deleteExtra(extra);
    if(response.isSuccess){
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.Message)));
    }
  }
}