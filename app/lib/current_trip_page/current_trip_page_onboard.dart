import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

  ScrollController scrollController = ScrollController();

  ///The controller of sliding up panel
  SlidingUpPanelController panelController = SlidingUpPanelController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
      } else {}
    });
    super.initState();
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
                    200), // Change this to change the position of the button
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
        SlidingUpPanelWidget(
          controlHeight:
              220.0, // Change this to change the visible part of the panel
          anchor: 1,
          panelController: panelController,
          onTap: () {
            ///Customize the processing logic
            if (SlidingUpPanelStatus.expanded == panelController.status) {
              panelController.collapse();
            } else {
              panelController.expand();
            }
          },
          enableOnTap: true, //Enable the onTap callback for control bar.
          child: Container(
            decoration: ShapeDecoration(
              color: Color(0xFFDAF2FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.0),
                  topRight: Radius.circular(28.0),
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 40.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: Color(0xFFA5E6FB),
                        size: 45,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Text("This is the sliding Widget"),
                  ), // TODO Put Current Trip Info Here
                ),
              ],
            ),
          ),
        ),
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
