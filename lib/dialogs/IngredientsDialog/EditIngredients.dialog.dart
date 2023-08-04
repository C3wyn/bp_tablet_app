import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:flutter/material.dart';

class EditIngredientsDialog extends StatefulWidget {
  final BPIngredient? ingredient;

  const EditIngredientsDialog({super.key, this.ingredient});

  @override
  State<EditIngredientsDialog> createState() => _EditIngredientsDialogState();
}

class _EditIngredientsDialogState extends State<EditIngredientsDialog> {

  TextEditingController _InpNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.ingredient!=null) _InpNameController.text = widget.ingredient!.Name?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
       title: Text(widget.ingredient!=null? '${widget.ingredient} bearbeiten': 'Zutat hinzufügen'),
       content: Column(
         children: [
           TextFormField(
             controller: _InpNameController
           )
         ],
       ),
       actions: [
        TextButton(
          child: const Text('Abbrechen'),
          onPressed: () => _onCanclePressed(context),
        ),
        ElevatedButton(
          onPressed: () => _onSavePressed(context), 
          child: const Text('Speichern')
        )
       ],
    );
  }

  void _onCanclePressed(BuildContext context) {
    Navigator.of(context).pop();
  }
  
  _onSavePressed(BuildContext context) async {
    APIResponse response;
    if(widget.ingredient==null){
      response = await APIService.addIngredient(_InpNameController.text);
    }else{
      response = await APIService.updateIngredient(widget.ingredient!, name: _InpNameController.text);
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.Message))
    );
    
    setState(() {
      widget.ingredient;
    });
  }
}