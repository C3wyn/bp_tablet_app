import 'package:bp_tablet_app/dialogs/CategoriesDialog/EditCategory.dialog.dart';
import 'package:bp_tablet_app/dialogs/DeleteDialog/delete.dialog.dart';
import 'package:bp_tablet_app/dialogs/OptionsDialog/options.dialog.dart';
import 'package:bp_tablet_app/models/category.model.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/APIService/Models/apiresponse.model.dart';
import 'package:flutter/material.dart';

class CategoryChipList extends StatefulWidget {

  BPCategory? selectedCategory;

  CategoryChipList({super.key, this.selectedCategory});

  @override
  State<CategoryChipList> createState() => _CategoryChipListState();
}

class _CategoryChipListState extends State<CategoryChipList> {

  late List<BPCategory> categories;
  @override
  void initState() {
    super.initState();
    categories = APIService.data.categories;
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> result = [];

    for(BPCategory category in categories){
      result.add(
        InkWell(
          onLongPress: () => _onChipHold(context, category),
          child: ChoiceChip(
            label: Text(category.Name), 
            selected: widget.selectedCategory?.ID==category.ID,
            onSelected: (selected) {
              setState(() {
                widget.selectedCategory = category;
              });
            },
          ),
        )
      );
    }

    result.add(
      InputChip(
        label: const Icon(Icons.add),
        onPressed: () => onAddCategoryClick(context)
      )
    );

    return Wrap(
      spacing: 5.0,
      children: result,
    );
  }

  void _onChipHold(BuildContext context, BPCategory category) {
    
    showModalBottomSheet(
      context: context, 
      builder: (builder){
        return OptionsDialog<BPCategory>(
          context: context,
          model: category,
          onEditClicked: (con, cat) => onEditClicked(con, cat),
          onDeleteClicked: (con, cat) => onDeleteClicked(con, cat),
        );
      }
    );
    
  }

  void onEditClicked(BuildContext context, BPCategory category) async {
    Navigator.of(context).pop();
    await showDialog(context: context, builder: (context) => EditCategoryDialog(category: category));
    setState(() {
      category;
    });
  }
  
  onAddCategoryClick(BuildContext context) async {
    await showDialog(
      builder: (_) => EditCategoryDialog(),
      context: context
    );
    setState(() {
      widget.selectedCategory;
      categories;
    });
  }
  
  onDeleteClicked(BuildContext con, BPCategory cat) async {
    Navigator.of(con).pop();
    await showDialog(context: con, builder: (_) => BPDeleteDialog(
      message: 'Möchtest du die Kategorie ${cat.Name}(ID: ${cat.ID}) unwiederruflich löschen?', 
      title: 'Kategorie löschen', 
      onDeletePressed: () => deleteCategory(cat)
      )
    );
  }

  deleteCategory(BPCategory cat) async {
    APIResponse response = await APIService.deleteCategory(cat);
    if(response.isSuccess){
      Navigator.of(context).pop();
    }
    setState(() {
      cat;
    });
  }
}