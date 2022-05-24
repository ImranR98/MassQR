import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tra_scan/models/scans.dart';
import 'package:vibration/vibration.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController controller = MobileScannerController();
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

  freezeScanner({bool pauseCam = true}) async {
    if (pauseCam) controller.stop();
    if (this.mounted) {
      setState(() {
        frozen = true;
      });
    }
  }

  unfreezeScanner() async {
    controller.start();
    if (this.mounted) {
      setState(() {
        frozen = false;
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    freezeScanner();
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
                          color: Colors.white,
                          icon: ValueListenableBuilder(
                            valueListenable: controller.torchState,
                            builder: (context, state, child) {
                              switch (state as TorchState) {
                                case TorchState.off:
                                  return const Icon(Icons.flash_off);
                                case TorchState.on:
                                  return const Icon(Icons.flash_on);
                              }
                              return null;
                            },
                          ),
                          onPressed: () => controller.toggleTorch(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: IconButton(
                          color: Colors.white,
                          icon: ValueListenableBuilder(
                            valueListenable: controller.cameraFacingState,
                            builder: (context, state, child) {
                              switch (state as CameraFacing) {
                                case CameraFacing.front:
                                  return const Icon(Icons.camera_front);
                                case CameraFacing.back:
                                  return const Icon(Icons.camera_rear);
                              }
                              return null;
                            },
                          ),
                          onPressed: () => controller.switchCamera(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: IconButton(
                            onPressed: frozen
                                ? () async {
                                    await unfreezeScanner();
                                  }
                                : null,
                            icon: frozen
                                ? Icon(Icons.play_arrow,
                                    color: Theme.of(context).primaryColor)
                                : Icon(Icons.pause)),
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
    return MobileScanner(
        key: qrKey,
        controller: controller,
        onDetect: (barcode, args) async {
          if (barcode.rawValue != null) {
            ScansModel scans = Provider.of<ScansModel>(context, listen: false);
            if (!scans.scans.contains(barcode.rawValue)) {
              scans.add(barcode.rawValue);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Added \'${barcode.rawValue}\'')));
              nextSounds.shuffle();
              await player.play(nextSounds[0], volume: 0.33);
              if (await Vibration.hasVibrator())
                Vibration.vibrate(duration: 50);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Skipped duplicate entry')));
              skipSounds.shuffle();
              await player.play(skipSounds[0], volume: 0.33);
              if (await Vibration.hasVibrator()) Vibration.vibrate();
            }
          }
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
