import 'dart:convert';

import 'package:bp_tablet_app/pages/MainPage/main.page.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.page.dart';
import 'package:bp_tablet_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight])
      .then((value) => runApp(BPTabletApp()));
}
class BPTabletApp extends StatelessWidget {
  const BPTabletApp
({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: BPTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => BPMainPage(),
        '/product': (context) => ProductSettingsPage()
      },
    );
  }
}