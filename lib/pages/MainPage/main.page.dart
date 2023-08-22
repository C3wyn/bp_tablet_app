import 'package:bp_tablet_app/pages/MainPage/main.controller.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/CartService/Cart.service.dart';
import 'package:flutter/material.dart';

class BPMainPage extends StatefulWidget {
  const BPMainPage({super.key});

  @override
  State<BPMainPage> createState() => _BPMainPageState();
}

class _BPMainPageState extends State<BPMainPage> {

  BPMainPageController controller = BPMainPageController();

  @override
  Widget build(BuildContext context) {
    var createController = controller.gatherData(context);

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
        future: createController,
        builder: (BuildContext builder, AsyncSnapshot snapshot) {
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width*.7,
                child: GridView.builder(
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
                      onTap: () async {
                        await controller.onProductClick(context, controller.Products[index]);
                        setState((){
                        
                        controller.Products;
                        APIService.data.products;
                      });
                      },
                      onLongPress: () => controller.onProductLongPress(context, controller.Products[index]),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1/1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width*.3,
                child: Column(
                  children: [
                    Text('Bestellung', style: Theme.of(context).textTheme.headlineLarge),
                    Divider(),
                    ListView.builder(
                      itemCount: CartService.currentOrder.orderItems.length,
                      shrinkWrap: true,
                      itemBuilder:(context, index) {
                        return ListTile(
                          title: Text(CartService.currentOrder.orderItems[index].product.Name)
                        );
                      },
                    )
                  ],
                )
              )
            ]
          );
      }
    )
  );
  }
}