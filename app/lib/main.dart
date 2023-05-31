import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "page_manager.dart";
import 'package:beacons_plugin/beacons_plugin.dart';
import 'structures/beacon.dart';
import 'package:restart_app/restart_app.dart';
import 'package:permission_handler/permission_handler.dart';
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
  String _beaconResult = 'Not Scanned Yet.';
  var isRunning = false;
  List<String> _results = [];
  bool _isInForeground = true;

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    permissions();
    initPlatformState();
    BeaconsPlugin.startMonitoring();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    beaconEventsController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void permissions() async {
    // Check permissions
    if (await Permission.bluetoothScan.isDenied ||
        await Permission.location.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
      // Restart.restartApp(); //Restart after permission granted (Android)
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!(await Permission.bluetoothScan.isGranted &&
        await Permission.location.isGranted)) {
      print("Permissions are not granted");
    } else {
      print("Permissions granted");
      if (Platform.isAndroid) {
        //Prominent disclosure
        await BeaconsPlugin.setDisclosureDialogMessage(
            title: "Background Locations",
            message:
                "[This app] collects location data to enable [feature], [feature], & [feature] even when the app is closed or not in use");

        //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
        //await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
      }

      if (Platform.isAndroid) {
        BeaconsPlugin.channel.setMethodCallHandler((call) async {
          print("Method: ${call.method}");
          if (call.method == 'scannerReady') {
            print("Beacons monitoring started..");
            await BeaconsPlugin.startMonitoring();
            setState(() {
              isRunning = true;
            });
          } else if (call.method == 'isPermissionDialogShown') {
            print("Prominent disclosure message is shown to the user!");
          }
        });
      }

      BeaconsPlugin.listenToBeacons(beaconEventsController);

      await BeaconsPlugin.addRegion(
          "Termini", "61d09100-f9a2-43aa-b727-9d1a6f7a2bc2");
      await BeaconsPlugin.addRegion(
          "Padova", "aae16383-257d-4a16-8eab-734c28084801");
      await BeaconsPlugin.addRegion(
          "FR9422", "c29ce823-e67a-4e71-bff2-abaa32e77a98");

      BeaconsPlugin.addBeaconLayoutForAndroid(
          "m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25");
      BeaconsPlugin.addBeaconLayoutForAndroid(
          "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24");

      BeaconsPlugin.setForegroundScanPeriodForAndroid(
          foregroundScanPeriod: 1100, foregroundBetweenScanPeriod: 2200);

      BeaconsPlugin.setBackgroundScanPeriodForAndroid(
          backgroundScanPeriod: 2200, backgroundBetweenScanPeriod: 10);

      beaconEventsController.stream.listen(
          (data) {
            if (data.isNotEmpty && isRunning) {
              // We hypothesize that there is only one beacon in the area at a time (for now) so we can just take the first one
              setState(() {
                _beaconResult = data;
                Beacon beacon = Beacon.fromString(data);
                print(beacon.uuid);
                // Check if the beacon belongs to one of the stations or to a train and then do the appropriate action
              });

              if (!_isInForeground) {
                // print("Print in background");
                print("Beacons DataReceived: " + data);
              }

              print("Beacons DataReceived: " + data);
            }
          },
          onDone: () {},
          onError: (error) {
            print("Error: $error");
          });

      //Send 'true' to run in background
      await BeaconsPlugin.runInBackground(true);

      if (!mounted) return;
    }
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
