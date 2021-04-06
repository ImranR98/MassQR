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
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Consumer<ScansModel>(
                    builder: (context, scans, child) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(scans.scans.length == 0
                                ? 'No scans yet. Use the Scan button to start.'
                                : '${scans.scans.length} Scan${scans.scans.length > 1 ? 's' : ''}:'),
                            (scans.scans.length > 0
                                ? ListView(
                                    children: scans.scans
                                        .map((e) => Container(
                                              child: Text(e),
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 10),
                                            ))
                                        .toList(),
                                    shrinkWrap: true,
                                  )
                                : Text('')),
                            Row(children: [
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ScanPage(),
                                          ));
                                    },
                                    child: Text('Scan')),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: scans.scans.length == 0
                                        ? null
                                        : () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ScanPage(),
                                                ));
                                          },
                                    child: Text('Save')),
                              )
                            ]),
                          ]);
                    },
                  ))),
        ],
      ),
    );
  }
}
