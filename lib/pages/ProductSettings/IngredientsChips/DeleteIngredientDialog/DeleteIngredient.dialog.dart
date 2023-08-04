import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:flutter/material.dart';
class DeleteIngredientDialog extends StatelessWidget {

  final BPIngredient ingredient;

  const DeleteIngredientDialog({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zutat löschen'),
      content: Text('Möchten Sie die Zutat $ingredient wirklich endgültig löschen?'),
      actions: [
        TextButton(
          child: const Text('Abbrechen'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () => _deleteIngredient(context, ingredient),
          child: const Text('Löschen')
        )
      ],
    );
  }

  _deleteIngredient(BuildContext context, BPIngredient ingredient) async {
    APIResponse result = await APIService.deleteIngredient(ingredient);
    if(result.Code==200) {
      Navigator.of(context).pop();
    }
  }
}
