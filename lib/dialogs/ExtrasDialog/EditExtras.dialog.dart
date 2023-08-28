import 'package:bp_tablet_app/models/extra.model.dart';
import 'package:bp_tablet_app/models/ingredient.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:flutter/material.dart';

class EditExtrasDialog extends StatefulWidget {
  final BPExtra? extra;

  const EditExtrasDialog({super.key, this.extra});

  @override
  State<EditExtrasDialog> createState() => _EditExtrasDialogState();
}

class _EditExtrasDialogState extends State<EditExtrasDialog> {

  TextEditingController _InpNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.extra!=null) _InpNameController.text = widget.extra!.Name?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
       title: Text(widget.extra!=null? '${widget.extra} bearbeiten': 'Extra hinzufügen'),
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
    if(widget.extra==null){
      response = await APIService.addExtra(_InpNameController.text);
    }else{
      response = await APIService.updateExtra(widget.extra!, name: _InpNameController.text);
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.Message))
    );
    
    setState(() {
      widget.extra;
    });
  }
}