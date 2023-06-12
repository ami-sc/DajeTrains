import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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

  @override
  Widget build(BuildContext context) {
    bool showFab = true;

    return Scaffold(
      body: SlidingUpPanel(
        onPanelOpened: () => {
          showFab = false,
        },
        onPanelClosed: () => {
          showFab = true,
        },
        minHeight: 180,
        maxHeight: 765,
        color: Color(0xFFDAF2FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
        ),
        panel: Center(
          child: Text("This is the sliding Widget"),
        ),
        body: OSMFlutter(
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
      floatingActionButton: showFab
          ? Padding(
              padding: EdgeInsets.only(bottom: 185),
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
                          return QRDialog("12345");
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
            )
          : null,
    );
  }
}

class QRDialog extends StatelessWidget {
  final String qrCode;

  QRDialog(this.qrCode);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      titlePadding: const EdgeInsets.all(0),
      backgroundColor: Color(0xFFE1F8FF),
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
      content: Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Add image here",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          )),
    );
  }
}