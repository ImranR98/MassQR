import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:tra_scan/models/scans.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  bool frozen = false;
  final AudioCache player = AudioCache(prefix: 'assets/sounds/');
  final List<String> nextSounds = [
    'AnotherOne.mp3',
    'Continue.mp3',
    'Next.mp3',
    'Nyingine.mp3',
    'OneMore.mp3'
  ];
  final List<String> skipSounds = [
    'AlreadyDone.mp3',
    'Duplicate.mp3',
    'Skipping.mp3',
    'TayariHiyo.mp3'
  ];

  freezeScanner({bool pauseCam = false}) async {
    if (pauseCam) controller?.pauseCamera();
    if (this.mounted) {
      setState(() {
        frozen = true;
      });
    }
  }

  unfreezeScanner() async {
    controller?.resumeCamera();
    if (this.mounted) {
      setState(() {
        frozen = false;
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    freezeScanner(pauseCam: true);
    unfreezeScanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TRAScan | Scan'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: IconButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            icon: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Icon(snapshot.data != null
                                    ? Icons.flash_on
                                    : Icons.flash_off);
                              },
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: IconButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            icon: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                return snapshot.data != null
                                    ? Icon(Icons.switch_camera)
                                    : Icon(Icons.warning);
                              },
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      var wasFrozen = frozen;
      await freezeScanner();
      if (!wasFrozen) {
        ScansModel scans = Provider.of<ScansModel>(context, listen: false);
        if (!scans.scans.contains(scanData.code)) {
          scans.add(scanData.code);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 1),
              content: Text('Added \'${scanData.code}\'')));
          nextSounds.shuffle();
          await player.play(nextSounds[0], volume: 0.33);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 1),
              content: Text('Skipped duplicate entry')));
          skipSounds.shuffle();
          await player.play(skipSounds[0], volume: 0.33);
        }

        Timer(Duration(seconds: 1), () async => {await unfreezeScanner()});
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
