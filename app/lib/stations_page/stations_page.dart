import 'package:flutter/material.dart';

import "stations_top_bar.dart";
import "station_list.dart";
import "single_station_page.dart";

import "../structures/station.dart";
import "../api/stations_api.dart";

class StationsPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> drawerId;

  const StationsPage({
    required this.drawerId,
    super.key,
  });

  @override
  State<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> {
  bool _defaultMessage = true;

  // Initialize an instance of the API.
  StationsApi stationsApi = StationsApi();
  List<Station> stationList = [];

  void _searchStation(String query) async {
    // Wait 500 milliseconds before sending a search request.
    // This is so we do not overload the API.
    await Future.delayed(const Duration(milliseconds: 500));

    List<Station> apiList = await stationsApi.getStationsFromApi(query);

    if (apiList.isNotEmpty) {
      // Trigger update of the station list.
      setState(() {
        _defaultMessage = false;
        stationList = apiList;
      });
    } else {
      setState(() {
        _defaultMessage = true;
      });
    }
  }

  void _toggleStationPage(Station station) {
    // Hide the keyboard, if active.
    FocusManager.instance.primaryFocus?.unfocus();

    // Open the page.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SingleStationPage(station: station)),
    );
  }

  // Needed in case the user leaves the page before the API responds.
  @override
  void setState(fx) {
    if(mounted) {
      super.setState(fx);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StationsTopBar(
        drawerId: widget.drawerId,
        searchCallback: _searchStation,
      ),

      body: _defaultMessage ? DefaultMessage() : StationList(
        stationList: stationList,
        stationCallback: _toggleStationPage,
      )
    );
  }
}

class DefaultMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Color.fromARGB(255, 174, 174, 174),
            size: 60,
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Search for a station to begin",
              style: TextStyle(
                color: Color.fromARGB(255, 174, 174, 174),
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
