import 'package:flutter/material.dart';
import 'package:myduit/features/presentation/pages/route.dart' as route;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Duit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: route.controller,
      initialRoute: route.homePage,
    );
  }
}
