import 'package:bp_tablet_app/pages/MainPage/main.controller.dart';
import 'package:flutter/material.dart';

class BPMainPage extends StatefulWidget {
  const BPMainPage({super.key});

  @override
  State<BPMainPage> createState() => _BPMainPageState();
}

class _BPMainPageState extends State<BPMainPage> {

  var controller = BPMainPageController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back Point'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {Navigator.of(context).pushNamed('/product');},
          )
        ],
      ),
      body: GridView.builder(
        itemCount: controller.Products.length,
        itemBuilder: (BuildContext context, int index) { 
          return InkWell(
            child: Container(
              alignment: Alignment.center,
              child: Text(controller.Products[index].Name, style: TextStyle(fontSize: 32))
            ),
            onTap: () => controller.onProductClick(context, controller.Products[index])
          );
        },
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20
        ),
      )
    );
  }
}