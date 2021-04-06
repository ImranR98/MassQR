import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tra_scan/models/scans.dart';
import 'package:tra_scan/pages/home.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ScansModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TRAScan',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: HomePage());
  }
}
