import 'package:bp_tablet_app/models/bpmodel.model.dart';
import 'package:flutter/material.dart';

class OptionsDialog<T> extends StatelessWidget {

  T model;
  BuildContext context;

  Function(BuildContext context, T model)? onSelectClicked;
  Function(BuildContext context, T model) onEditClicked;
  Function(BuildContext context, T model)? onDeleteClicked;

  OptionsDialog({
    super.key,
    required this.model,
    required this.context,
    this.onSelectClicked,
    required this.onEditClicked,
    this.onDeleteClicked
  });

  @override
  Widget build(BuildContext context) {

    List<ListTile> tiles = [
      _createTile(onSelectClicked, 'Auswählen', const Icon(Icons.select_all)),
      _createTile(onEditClicked, 'Bearbeiten', const Icon(Icons.edit)),
      _createTile(onDeleteClicked, 'Löschen', const Icon(Icons.delete))
    ];

    return ListView(
      shrinkWrap: true,
      children: tiles
    );
  }

  _createTile(Function(BuildContext context, T model)? fn, String title, Icon icon) {
    if(fn == null){
      return ListTile(
        leading: icon,
        title: Text(title),
        enabled: false,
      );
    }
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: () => fn(context, model)
    );
  }
}