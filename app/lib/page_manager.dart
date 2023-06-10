import "package:flutter/material.dart";
import "dart:async";
import "dart:io" show Platform;

import "top_bar.dart";
import "bottom_bar.dart";
import "nav_drawer.dart";

/*** Bottom Bar Pages ***/
import "current_trip_page/current_trip_page.dart";
import "stations_page/stations_page.dart";
import "trains_page/trains_page.dart";

/*** Drawer Pages ***/
import "history_page/history_page.dart";
import "qr_code_scan_page/qr_code_scan_page.dart";
import "settings_page/settings_page.dart";
import "help_page/help_page.dart";

/*** Beacon library ***/
import 'package:beacons_plugin/beacons_plugin.dart';
import 'structures/beacon.dart';

/*** Notifications ***/
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notifications/noti.dart';

/*** User location ***/
import 'api/user_location.dart';
import 'structures/position.dart';

/*** Single train page ***/
import 'single_train_info/single_train_page.dart';

/*** Station  ***/
import 'structures/station.dart';
import 'stations_page/single_station_page.dart';

/*** Global variables ***/
import 'globals.dart' as globals;

/*** Payments ***/
import 'api/payments_api.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  int _drawerIdx = 0;
  int _activePageIdx = 0;
  int _previousPageIdx = 0;
  bool _topBarState = true;
  bool _bottomBarState = true;
  PageController _pageControl = PageController(initialPage: 0);
  String _lastBeaconID = "";

  /* Beacon monitoring */
  var isRunning = false;
  bool _isInForeground = true;

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  /* Notifications */
  late final Noti noti;

  void listenToNotification() =>
      noti.onNotificationClick.stream.listen(onNotificaionListener);

  void onNotificaionListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');
      // Split the payload to get the train ID
      List<String> payloadList = payload.split(',');
      print(payloadList);
      if (payloadList[1] == "in_train") {
        // If the user is in a train, send him to the single train page
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) =>
                    SingleTrainPage(trainID: payloadList[0]))));
      } else if (payloadList[1] == "in_station") {
        // Build a station object from the payload
        Station station = Station(
          name: payloadList[0],
          beaconId: "",
          location: Location(
            latitude: 0,
            longitude: 0,
          ),
        );
        // If the user is in a station, send him to the single station page
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => SingleStationPage(station: station))));
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    /*var lista = PaymentsApi.getPaymentsHistory();
    lista.then((value) => {print("Test"), print(value), print(value[0].cost)});*/
    initPlatformState();
    BeaconsPlugin.startMonitoring();
    noti = Noti();
    noti.initialize();
    listenToNotification();
    super.initState();
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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
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
    await BeaconsPlugin.addRegion(
        "Napoli Centrale", "c7ed8863-f368-4810-bb06-998ec4316987");

    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25");
    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24");

    BeaconsPlugin.setForegroundScanPeriodForAndroid(
        foregroundScanPeriod: 1100, foregroundBetweenScanPeriod: 10);

    BeaconsPlugin.setBackgroundScanPeriodForAndroid(
        backgroundScanPeriod: 2200, backgroundBetweenScanPeriod: 10);

    beaconEventsController.stream.listen(
        (data) {
          if (data.isNotEmpty && isRunning) {
            // We hypothesize that there is only one beacon in the area at a time (for now) so we can just take the first one
            setState(() {
              Beacon beacon = Beacon.fromString(data);
              // Check if the beacon belongs to one of the stations or to a train and then do the appropriate action
            });
            Beacon beacon = Beacon.fromString(data);
            if (_lastBeaconID != beacon.uuid) {
              _lastBeaconID = beacon.uuid;

              PositionApi userPosition = PositionApi(beaconID: beacon.uuid);
              Future<Position> posizione = userPosition.updatePosition();
              posizione.then(
                (value) => {
                  print(value.status),
                  if (value.status == "in_train")
                    {
                      // User is in a train, send him to the trip page
                      globals.ticketValue = value.ticket,
                      noti.showNotificationWithPayload(
                          id: 0,
                          title: "Test notification",
                          body: "Your are on train ${value.id}",
                          payload: value.toString())
                    }
                  else if (value.payment != null)
                    {
                      // User got off the train, send him to the payment info
                      noti.showNotificationWithPayload(
                        id: 0,
                        title: "Station detected",
                        body:
                            "You got of at ${value.id} station click here to see the payment details",
                        payload: value.toString(),
                      )
                    }
                  else
                    {
                      // User arrived at the station, send him the schedule of the station
                      noti.showNotificationWithPayload(
                        id: 0,
                        title: "Station detected",
                        body:
                            "You are in ${value.id} station click here to see the schedule",
                        payload: value.toString(),
                      )
                    }
                },
              );
            }

            if (!_isInForeground) {
              // print("Print in background");
              print("Beacons DataReceived: $data");
            }

            print("Beacons DataReceived: $data");
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

  void _hideTopBar() {
    setState(() {
      _topBarState = false;
    });
  }

  void _showTopBar() {
    setState(() {
      _topBarState = true;
    });
  }

  void _hideBottomBar() {
    setState(() {
      _bottomBarState = false;
    });
  }

  void _showBottomBar() {
    setState(() {
      _bottomBarState = true;
    });
  }

  void _previousPage() {
    // Hide the keyboard, if active.
    FocusManager.instance.primaryFocus?.unfocus();

    _pageControl.jumpToPage(_previousPageIdx);

    if (_previousPageIdx != 0) {
      _hideTopBar();
    } else {
      _showTopBar();
    }

    setState(() {
      _activePageIdx = _previousPageIdx;
    });
  }

  void _changePage(int targetIdx) {
    // Hide the keyboard, if active.
    FocusManager.instance.primaryFocus?.unfocus();

    // Only the "Current Trip" page should have the main top bar.
    if (targetIdx != 0) {
      _hideTopBar();
    } else {
      _showTopBar();
    }

    // If the target index < 3, we want a page from the bottom bar.
    if (targetIdx < 3) {
      // All bottom bar pages need the bottom bar.
      _showBottomBar();

      // Avoid overwritting previousIdx if the user clicks the same page.
      if (targetIdx != _activePageIdx) {
        setState(() {
          _previousPageIdx = _activePageIdx;
          _activePageIdx = targetIdx;
        });
      }

      // Update the highlighted button in the drawer.
      _drawerIdx = 0;
    }
    // If the target index >= 3, we want a page from the drawer.
    else {
      // No drawer page needs the bottom bar.
      _hideBottomBar();

      // Update the highlighted button in the drawer.
      _drawerIdx = targetIdx - 2;
    }

    // Change page.
    _pageControl.jumpToPage(targetIdx);
  }

  @override
  Widget build(BuildContext context) {
    NavDrawer drawer = NavDrawer(
      indexCallback: _changePage,
      targetIdx: _drawerIdx,
    );

    return Scaffold(
      appBar: _topBarState ? CurrentTripTopBar() : null,

      // Needed for the round corners of the bottom bar.
      extendBody: true,

      drawer: drawer,
      // Swipe left to right to open the drawer
      drawerEdgeDragWidth: 200,

      body: PageView(
        controller: _pageControl,

        // Disable scrolling between pages.
        physics: NeverScrollableScrollPhysics(),

        children: <Widget>[
          /*** 0: Current Trip Page ***/
          CurrentTripPage(),

          /*** 1: Stations Page ***/
          StationsPage(
            backButtonCallback: _previousPage,
          ),

          /*** 2: Trains Page ***/
          TrainsPage(),

          /*** 3: History Page ***/
          HistoryPage(appDrawer: drawer),

          /*** 4: QR Code Page ***/
          QRCodePage(appDrawer: drawer),

          /*** 5: Settings Page ***/
          SettingsPage(appDrawer: drawer),

          /*** 6: Help Page ***/
          HelpPage(appDrawer: drawer),
        ],
      ),

      bottomNavigationBar: _bottomBarState
          ? BottomBar(
              pageCallback: _changePage,
              activeIdx: _activePageIdx,
            )
          : null,
    );
  }
}
