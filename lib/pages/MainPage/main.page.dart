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
          if(!snapshot.hasData) {
            return Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  Text('Lade Daten...', style: Theme.of(context).textTheme.bodyMedium)
                ],
              )
            );
          }
          return Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width*.7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: controller.Products.length,
                    itemBuilder: (BuildContext context, int index) { 
                      return InkWell(
                        child: Card(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              controller.Products[index].Name, 
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            )
                          ),
                        ),
                        onTap: () async {
                          await controller.onProductClick(context, controller.Products[index]);
                          setState((){
                            controller.Products;
                            APIService.data.products;
                            CartService.currentOrder;
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width*.3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Bestellung', style: Theme.of(context).textTheme.displayMedium),
                      const Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: CartService.currentOrder.orderItems.length,
                          shrinkWrap: true,
                          itemBuilder:(context, index) {
                            return ListTile(
                              title: Text(CartService.currentOrder.orderItems[index].product.Name, style: Theme.of(context).textTheme.bodyLarge),
                              leading: Text('#${index + 1}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: CartService.currentOrder.orderItems.isEmpty? null: () async {
                            await controller.onSendOrderClicked(context);
                            setState((){
                              CartService.currentOrder;
                            });
                          }, 
                          label: const Text('Bestellen'),
                          style: Theme.of(context).elevatedButtonTheme.style
                        ),
                      )
                    ],
                  ),
                )
              )
            ]
          );
      }
    )
  );
  }
}