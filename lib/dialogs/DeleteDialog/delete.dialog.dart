import 'package:flutter/material.dart';

class BPDeleteDialog extends StatelessWidget {

  late String message;
  late String title;
  late Function() onDeletePressed;

  BPDeleteDialog(
    {
      super.key,
      required this.message,
      required this.title,
      required this.onDeletePressed
    }
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Abbrechen'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () => onDeletePressed(),
          child: const Text('Löschen')
        )
      ],
    );
  }
}