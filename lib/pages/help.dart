import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String exportDir = '';

  void setDirectory() async {
    String temp = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      exportDir = temp + '/scans';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TRAScan | Help'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scan QR Codes.',
                  textScaleFactor: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<Directory>(
                    future: getApplicationDocumentsDirectory(),
                    builder: (context, AsyncSnapshot<Directory> snapshot) {
                      final helpTextStart =
                          'Press the scan button to scan QR codes and add them to the scans list. Duplicate entries are skipped automatically.\n\n' +
                              'After scanning all codes, go back to the main screen to view them.\n\n' +
                              'Use the save button to save a copy of the list to storage.\n\n';
                      final helpTextEnd =
                          'To process the file (extract TRA receipt data), use the TRAExtract PC app, available at the link below.\n';
                      if (snapshot.hasData) {
                        return Text(helpTextStart +
                            'The files are saved in:\n\'${snapshot.data.path}\'\n\n' +
                            helpTextEnd);
                      } else
                        return Text(helpTextStart + '' + helpTextEnd);
                    }),
                InkWell(
                  onTap: () {
                    launch('https://github.com/ImranR98/TRAExtract');
                  },
                  child: Text(
                    'Get TRAExtract',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Made for Papa.'),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          launch('https://imranr.dev');
                        },
                        child: Text(
                          'Website',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launch('https://github.com/ImranR98/TRAScan');
                        },
                        child: Text(
                          'Source',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      )
                    ]),
              ],
            )
          ],
        ),
      ),
    );
  }
}
