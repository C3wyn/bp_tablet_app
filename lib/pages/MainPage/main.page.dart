import 'package:bp_tablet_app/pages/MainPage/main.controller.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:flutter/material.dart';

class BPMainPage extends StatefulWidget {
  const BPMainPage({super.key});

  @override
  State<BPMainPage> createState() => _BPMainPageState();
}

class _BPMainPageState extends State<BPMainPage> {

  BPMainPageController controller = BPMainPageController();

  Future<BPMainPageController> _createController() async => controller.gatherData(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back Point'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.of(context).pushNamed('/product');
              setState(() {
                controller.Products;
              });
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _createController(),
        builder: (BuildContext builder, AsyncSnapshot snapshot) {

          if(!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return GridView.builder(
          itemCount: controller.Products.length,
          itemBuilder: (BuildContext context, int index) { 
            return InkWell(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  controller.Products[index].Name, 
                  style: TextStyle(fontSize: 32),
                  textAlign: TextAlign.center,
                )
              ),
              onTap: () => controller.onProductClick(context, controller.Products[index]),
              onLongPress: () => controller.onProductLongPress(context, controller.Products[index]),
            );
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20
          ),
        );
      }
    )
  );
  }
}