import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String exportDir = '';

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
                  'Scan QR codes in quick succession.',
                  textScaleFactor: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'Designed for use with TRA receipts that link to pages on https://verify.tra.go.tz.'),
                SizedBox(
                  height: 10,
                ),
                Text('Press the scan button to scan QR codes and add them to the scans list. Duplicate entries are skipped automatically.\n\n' +
                    'After scanning all codes, go back to the main screen to view them.\n\n' +
                    'Use the Export button to share the list to other apps.\n\n' +
                    'You may want to use the Export feature to email the list to yourself. Be sure to do this BEFORE exiting the app, as the in-app list is not stored permanently.\n\n' +
                    'To process the file (extract TRA receipt data), use the TRAExtract PC app, available at the link below.\n'),
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
