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
      title: const Text('Liefertyp auswählen'),
      content: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => _chooseDeliveryOption(context, OrderDeliveryType.EatHere),
                style: Theme.of(context).outlinedButtonTheme.style,
                child: Column(
                children: [
                  Icon(Icons.home, size: Theme.of(context).textTheme.displayLarge!.fontSize! * 2.5),
                  Text('Hier essen', style: Theme.of(context).textTheme.displayLarge)
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => _chooseDeliveryOption(context, OrderDeliveryType.TakeAway),
              child: Column(
                children: [
                  Icon(Icons.delivery_dining, size: Theme.of(context).textTheme.displayLarge!.fontSize! * 2.5),
                  Text('Zum Mitnehmen', style: Theme.of(context).textTheme.displayLarge)
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