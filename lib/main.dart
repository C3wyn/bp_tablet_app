import 'package:bp_tablet_app/pages/MainPage/main.page.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BPTabletApp());
}
class BPTabletApp extends StatelessWidget {
  const BPTabletApp
({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => BPMainPage(),
        '/product': (context) => ProductSettingsPage()
      },
    );
  }
}