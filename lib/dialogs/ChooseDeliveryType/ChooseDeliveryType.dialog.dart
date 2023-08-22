import 'package:bp_tablet_app/models/Order/orderdeliverytype.enum.dart';
import 'package:bp_tablet_app/services/APIService/APIService.dart';
import 'package:bp_tablet_app/services/CartService/Cart.service.dart';
import 'package:flutter/material.dart';

class ChooseDeliveryTypeDialog extends StatefulWidget {
  const ChooseDeliveryTypeDialog({super.key});

  @override
  State<ChooseDeliveryTypeDialog> createState() => _ChooseDeliveryTypeDialogState();
}

class _ChooseDeliveryTypeDialogState extends State<ChooseDeliveryTypeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Liefertyp auswählen', style: Theme.of(context).textTheme.headlineLarge),
      content: SizedBox(
        child: Row(
          children: [
            OutlinedButton(
              onPressed: () => _chooseDeliveryOption(context, OrderDeliveryType.EatHere),
              child: Column(
                children: [
                  Icon(Icons.home, size: Theme.of(context).textTheme.displayLarge?.fontSize),
                  Text('Hier essen', style: Theme.of(context).textTheme.headlineLarge)
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => _chooseDeliveryOption(context, OrderDeliveryType.TakeAway),
              child: Column(
                children: [
                  Icon(Icons.delivery_dining, size: Theme.of(context).textTheme.displayLarge?.fontSize),
                  Text('Mitnehmen', style: Theme.of(context).textTheme.headlineLarge)
                ],
              ),
            )
          ],
        ),
      )
    );
  }
  
  _chooseDeliveryOption(BuildContext context, OrderDeliveryType type) async {
    CartService.currentOrder.deliveryType = type;
    var result = await APIService.addOrder(CartService.currentOrder);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.Name)
      )
    );
    if(result.isSuccess){
      Navigator.of(context).pop();
    }
  }
}