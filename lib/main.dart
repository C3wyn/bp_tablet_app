import 'dart:convert';

import 'package:bp_tablet_app/pages/MainPage/main.page.dart';
import 'package:bp_tablet_app/pages/ProductSettings/productsettings.page.dart';
import 'package:bp_tablet_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeStr = await rootBundle.loadString('assets/theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight])
      .then((value) => runApp(BPTabletApp(theme: theme)));
}
class BPTabletApp extends StatelessWidget {
  final ThemeData theme;
  const BPTabletApp
({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => BPMainPage(),
        '/product': (context) => ProductSettingsPage()
      },
    );
  }
}