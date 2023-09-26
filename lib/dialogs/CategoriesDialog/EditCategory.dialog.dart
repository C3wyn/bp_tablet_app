import 'dart:io';

import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EditCategoryDialog extends StatefulWidget {

  BPCategory? category;

  EditCategoryDialog({super.key, this.category});

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {

  final TextEditingController _categoryNameController = TextEditingController();

  PlatformFile? file;

  @override
  void initState() {
    super.initState();
    if(widget.category!=null){
      _categoryNameController.text = widget.category!.Name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.category==null? const Text('Kategorie hinzufügen'): Text('Kategorie: ${widget.category!.Name} bearbeiten'),
      content: Column(
        children: [
          /*
          InkWell(
            child: const Column(
              children: [
                Text('Datei hochladen'),
                Icon(Icons.upload_file_outlined)
              ],
            ),
            onTap: () => _onFileUplaodClick(),
          ),
          */
          TextFormField(
            controller: _categoryNameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: Theme.of(context).inputDecorationTheme.labelStyle
            ),
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Abbrechen'),
          onPressed: () => _onAbortClicked(context),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          onPressed: () => _onSaveClicked(context), 
          label: const Text('Speichern')
        )
      ],
    );
  }
  /*
  _onFileUplaodClick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null){
      file = result.files.single;
    }
  }
  */
  _onSaveClicked(BuildContext context) async {
    APIResponse response;
    if(widget.category==null){
      response = await APIService.addCategory(_categoryNameController.text, file);
    }else{
      response = await APIService.updateCategory(widget.category!, name: _categoryNameController.text);
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.Message))
    );
    
    setState(() {
      widget.category;
    });
  }
  
  _onAbortClicked(BuildContext context) {
    Navigator.of(context).pop();
  }
}