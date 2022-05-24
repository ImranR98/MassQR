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
        title: Text('MassQR | Help'),
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
                  'Scan Several QR Codes in Quick Succession.',
                  textScaleFactor: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Press the "Scan" button to scan QR codes and add them to the scans list. Duplicate entries are skipped automatically.\n\n' +
                    'After scanning all codes, go back to the main screen to view them.\n\n' +
                    'Use the "Export" button to share the list to other apps.\n\n' +
                    'To clear the list, use the "Delete All" button or exit the app.\n'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Made for Papa.'),
                // SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          launchUrl(Uri(scheme: 'https', host: 'imranr.dev'),
                              mode: LaunchMode.externalApplication);
                        },
                        child: Text(
                          'Developer',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launchUrl(
                              Uri(
                                  scheme: 'https',
                                  host: 'github.com',
                                  path: '/ImranR98/MassQR'),
                              mode: LaunchMode.externalApplication);
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
