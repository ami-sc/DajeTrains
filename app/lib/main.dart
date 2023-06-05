import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "page_manager.dart";
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(DajeTrains());
}

class DajeTrains extends StatefulWidget {
  const DajeTrains({super.key});

  @override
  State<DajeTrains> createState() => _DajeTrainsState();
}

class _DajeTrainsState extends State<DajeTrains> with WidgetsBindingObserver {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    permissions();
  }

  void permissionsDenied() async {
    if ((await Permission.bluetoothScan.isDenied ||
        await Permission.location.isDenied)) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
    }
    var status = await Permission.bluetoothScan.status;
    var status2 = await Permission.location.status;
    if (status != PermissionStatus.granted ||
        status2 != PermissionStatus.granted) {
      // Open settings if permissions are denied
      openAppSettings();
    }
    if (await Permission.bluetoothScan.isGranted &&
        await Permission.location.isGranted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  void permissions() async {
    // Check permissions
    if ((await Permission.bluetoothScan.isDenied ||
        await Permission.location.isDenied)) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
    }
    if (await Permission.bluetoothScan.isGranted &&
        await Permission.location.isGranted) {
      setState(() {
        _isReady = true;
      });
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
        home: _isReady
            ? Home()
            : Scaffold(
                body: Center(
                  child: SizedBox(
                    height: 100,
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                      ),
                      onPressed: () {
                        permissionsDenied();
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            "Please give location and bluetooth permissions to use this app"),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class AppState extends ChangeNotifier {}
