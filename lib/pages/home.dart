import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tra_scan/models/scans.dart';
import 'package:tra_scan/pages/scan.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TRAScan'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScanPage(),
                    ));
              },
              child: Text('Scan')),
          Consumer<ScansModel>(
            builder: (context, scans, child) {
              return ListView(
                children: scans.scans.map((e) => Text(e)).toList(),
                shrinkWrap: true,
              );
            },
          )
        ],
      ),
    );
  }
}
