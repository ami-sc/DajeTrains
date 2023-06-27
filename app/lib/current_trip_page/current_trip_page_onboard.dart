import 'dart:async';

import 'package:DajeTrains/api/trip_api.dart';
import 'package:DajeTrains/single_train_info/single_train_page.dart';
import 'package:DajeTrains/single_train_info/single_train_top_bar.dart';
import 'package:DajeTrains/structures/train_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../structures/train.dart';
import 'package:dotted_line/dotted_line.dart';
import '../globals.dart' as globals;

class CurrentTripPageOnBoard extends StatefulWidget {
  @override
  State<CurrentTripPageOnBoard> createState() => _CurrentTripPageOnBoardState();
}

class _CurrentTripPageOnBoardState extends State<CurrentTripPageOnBoard> {
  final controller = MapController.withUserPosition(
      trackUserLocation: UserTrackingOption(
    enableTracking: true,
    unFollowUser: true,
  ));

  bool showFab = true;
  bool _delayed = false;
  bool _default = true;

  TripApi api = TripApi();
  TrainInfo? trainInfo;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _getTrainInfo();
  }

  void _getTrainInfo() async {
    List<TrainInfo> l = await api.getTrip(globals.trainID);
    print(l);

    if (l.isNotEmpty) {
      setState(() {
        trainInfo = l[0];
        _default = false;
        _delayed =
            (trainInfo!.lastDelay > 0) ? true : false; // CHANGE FOR DEBBUGGING
      });
    } else {
      throw Exception("Non valid Train ID");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 0.0),
              // PUT MAP HERE
              child: OSMFlutter(
                mapIsLoading: Center(child: CircularProgressIndicator()),
                controller: controller,
                initZoom: 12,
                minZoomLevel: 7,
                maxZoomLevel: 16,
                stepZoom: 0.5,
                userLocationMarker: UserLocationMaker(
                  personMarker: MarkerIcon(
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 80,
                      weight: 700,
                    ),
                  ),
                  directionArrowMarker: MarkerIcon(
                    icon: Icon(
                      Icons.double_arrow,
                      size: 48,
                    ),
                  ),
                ),
                roadConfiguration: RoadOption(
                  roadColor: Colors.yellowAccent,
                ),
                markerOption: MarkerOption(
                    defaultMarker: MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 56,
                  ),
                )),
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
                bottom:
                    175), // Change this to change the position of the button
            child: SizedBox(
              height: 65.0,
              width: 65.0,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: () {
                    print("Floating action button pressed");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return QRDialog(globals.ticketValue);
                      },
                    );
                  },
                  backgroundColor: Color(0xFFB5D7FF),
                  child: Icon(
                    Icons.qr_code_2,
                    size: 44,
                  ),
                ),
              ),
            ),
          ),
        ),
        SlidePanel2(),
      ],
    );
  }
}

class QRDialog extends StatelessWidget {
  final String qrCode;

  QRDialog(this.qrCode);

  @override
  Widget build(BuildContext context) {
    print(globals.ticketValue);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      titlePadding: const EdgeInsets.all(0),
      backgroundColor: Colors.white,
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.0),
            topRight: Radius.circular(28.0),
          ),
          color: Color(0xFFA5E6FB),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(Icons.confirmation_num),
                ),
                TextSpan(
                  text: " Your ticket",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      content: Wrap(
        children: [
          SizedBox(
            width: 400,
            child: QrImageView(
              data: globals.ticketValue,
              version: QrVersions.auto,
            ),
          ),
        ],
      ),
    );
  }
}

class SlidePanel2 extends StatefulWidget {
  @override
  State<SlidePanel2> createState() => _SlidePanel2State();

  static Widget trainRoute(TrainInfo trainInfo, bool delayed,
      [int first = 0, ScrollController? scrollController]) {
    return ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: trainInfo.trip.length - first + 4,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Container(
              alignment: Alignment.center,
              height: 20.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.horizontal_rule_rounded,
                    color: Color(0xFFA5E6FB),
                    size: 45,
                  )
                ],
              ),
            );
          }

          if (index == 1) {
            return SingleTrainTripTopBar.trainHeader(trainInfo!, delayed);
          }
          if (index == 2) {
            // Print a divider
            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Divider(
                color: Color.fromARGB(255, 201, 201, 201),
                height: 1,
              ),
            );
          }
          if (index == 3) {
            return Column(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(flex: 2, child: SizedBox.shrink()),
                        Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Stops",
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF616161)),
                                )
                              ],
                            )),
                        Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Platform",
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF616161)),
                                )
                              ],
                            ))
                      ],
                    )),
                (first > 0)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(35, 0, 20, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DottedLine(
                                        dashColor: Color(0xFFA5E6FB),
                                        direction: Axis.vertical,
                                        dashLength: 5,
                                        lineThickness: 5,
                                        dashGapLength: 2,
                                        dashRadius: 80,
                                        lineLength: 30,
                                      )
                                    ],
                                  ))),
                          Expanded(flex: 5, child: SizedBox.shrink()),
                          Expanded(flex: 3, child: SizedBox.shrink())
                        ],
                      )
                    : Row(),
              ],
            );
          }
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: TripStationView(
              tripStation: trainInfo.trip[first + index - 4],
              notLast: first + index - 4 < trainInfo.trip.length - 1,
              notFirst: first + index - 4 > 0,
              delayed: delayed,
              delay: trainInfo.lastDelay,
            ),
          );
        });
  }
}

class _SlidePanel2State extends State<SlidePanel2> {
  TripApi api = TripApi();
  TrainInfo? trainInfo;

  Timer? timer;

  bool _delayed = false;
  bool _default = true;

  void _getTrainInfo() async {
    List<TrainInfo> l = await api.getTrip(globals.trainID);
    print(l);

    if (l.isNotEmpty) {
      setState(() {
        trainInfo = l[0];
        _default = false;
        _delayed =
            (trainInfo!.lastDelay > 0) ? true : false; // CHANGE FOR DEBBUGGING
      });
    } else {
      throw Exception("Non valid Train ID");
    }
  }

  @override
  void dispose() {
    print("CurrentTripPageOnBoard dispose");
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    print("CurrentTripPageOnBoard init");
    _getTrainInfo();
    timer = Timer.periodic(Duration(seconds: 3),
        (Timer t) => _getTrainInfo()); // TODO periodically request
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.95,
      initialChildSize: 0.235,
      minChildSize: 0.235,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            decoration: ShapeDecoration(
              color: Color(0xFFDAF2FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.0),
                  topRight: Radius.circular(28.0),
                ),
              ),
            ),
            child: _default
                ? Column()
                : SlidePanel2.trainRoute(
                    trainInfo!,
                    _delayed,
                    trainInfo!.lastArrivedStation(),
                    scrollController = scrollController));
      },
    );
  }
}
