import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "page_manager.dart";
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io' show Platform;

void main() {
  runApp(DajeTrains());
}

class DajeTrains extends StatefulWidget {
  const DajeTrains({super.key});

  @override
  State<DajeTrains> createState() => _DajeTrainsState();
}

class _DajeTrainsState extends State<DajeTrains> with WidgetsBindingObserver {
  bool _isInForeground = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    String _beaconResult = 'Not Scanned Yet.';

    BeaconsPlugin.setDebugLevel(2);

    BeaconsPlugin.addRegion("myBeacon", "c29ce823-e67a-4e71-bff2-abaa32e77a98");
    print("Add Region");

    //IMPORTANT: Start monitoring once scanner is setup & ready (only for Android)
    if (Platform.isAndroid) {
      print("Android");
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        if (call.method == 'scannerReady') {
          print("Scanner Ready");
          await BeaconsPlugin.startMonitoring();
        }
      });
    }

    final StreamController<String> beaconEventsController =
        StreamController<String>.broadcast();
    BeaconsPlugin.listenToBeacons(beaconEventsController);

    BeaconsPlugin.setForegroundScanPeriodForAndroid(
        foregroundScanPeriod: 2200, foregroundBetweenScanPeriod: 10);

    beaconEventsController.stream.listen(
        (data) {
          print("Got some data");
          if (data.isNotEmpty) {
            setState(() {
              _beaconResult = data;
            });

            if (!_isInForeground) {
              print("Beacons DataReceived: " + data);
            }

            print("Beacons DataReceived: " + data);
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    //Send 'true' to run in background [OPTIONAL]
    await BeaconsPlugin.runInBackground(true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: "DajeTrains",
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: Home(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {}
