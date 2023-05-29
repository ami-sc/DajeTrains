import 'package:flutter/material.dart';

import 'current_trip_page/current_trip_top_bar.dart';
import 'qr_code_scan_page/qr_code_top_bar.dart';
import "bottom_bar.dart";
import 'nav_drawer.dart';

import 'current_trip_page/current_trip_page.dart';

import "stations_page/stations_page.dart";
import 'stations_page/stations_top_bar.dart';

import 'api/stations_api.dart';
import "../structures/station.dart";

import 'qr_code_scan_page/qr_code_scan_page.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // The index of the currently displayed page, as defined by the bottom bar.
  int currentIdx = 0;
  // The index of the page that was previously active.
  int previousIdx = 0;

  // Create an instance of the Stations API.
  StationsApi api = StationsApi();

  List<Station> stationList = [];

  // Return to the previous visited page.
  void _previousPage() {
    setState(() {
      currentIdx = previousIdx;
      previousIdx = currentIdx;

      // Reset the StationList.
      stationList = [];
    });
  }

  // Jump directly to a target page.
  void _changePage(int newIdx) {
    // Avoid overwritting previousIdx if the user clicks the same page.
    if (newIdx != currentIdx) {
      setState(() {
        previousIdx = currentIdx;
        currentIdx = newIdx;

        // Reset the StationList.
        stationList = [];
      });
    }
  }

  void _searchStation(String query) async {
    // Wait 500 milliseconds before sending a search request.
    // This is so we do not overload the API.
    await Future.delayed(const Duration(milliseconds: 500));

    List<Station> apiList = await api.getStationsFromApi(query);

    // Trigger update of the station list.
    setState(() {
      stationList = apiList;
    });
  }

  // Homepage index
  int drawerIdx = 0;
  // This value is used to decide if we need to show the bottom bar
  int drawerPages = 0;

  void _onLabelTap(int newIdx) {
    setState(() {
      drawerIdx = newIdx;
      print("SideMenu value:");
      print(drawerIdx);
      if (drawerIdx != 0) {
        drawerPages = 1;
      } else {
        drawerPages = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEdgeDragWidth: 200, // Swipe left to right to open the drawer
        appBar: <PreferredSizeWidget>[
          <PreferredSizeWidget>[
            /*** Current Trip App Bar ***/
            CurrentTripTopBar(),

            /*** Stations App Bar ***/
            StationsTopBar(
              backButtonCallback: _previousPage,
              searchCallback: _searchStation,
            ),

            /*** Trains App Bar ***/
            CurrentTripTopBar(),
          ][currentIdx],

          /*** History App Bar ***/
          CurrentTripTopBar(),

          /*** QR Code App Bar ***/
          QRCodeTopBar(),

          /*** Settings App Bar ***/
          QRCodeTopBar(),

          /*** Help App Bar ***/
          QRCodeTopBar(),
        ][drawerIdx],
        drawer: NavDrawer(
          indexCallback: _onLabelTap,
          targetIdx: drawerIdx,
        ),

        // Needed for the round corners of the bottom bar.
        extendBody: true,
        body: <Widget>[
          <Widget>[
            /*** Current Trip Page ***/
            Container(
              alignment: Alignment.center,
              child: CurrentTripPage(),
            ),

            /*** Stations Page ***/
            Container(
              alignment: Alignment.center,
              child: StationsPage(
                stationList: stationList,
              ),
            ),

            /*** Trains Page ***/
            Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text('Trains Page'),
            ),
          ][currentIdx],

          /*** History Page ***/
          Container(
            alignment: Alignment.center,
            child: Text("History page needs to be completed"),
          ),

          /*** QR Code Scan Page ***/
          Container(
            alignment: Alignment.center,
            child: QRCodeWidget(),
          ),

          /*** Settings Page ***/
          Container(
            alignment: Alignment.center,
            child: Text("Settings need to be completed"),
          ),

          /*** Help Page ***/
          Container(
            alignment: Alignment.center,
            child: Text("Help page needs to be completed"),
          ),
        ][drawerIdx],
        bottomNavigationBar: <Widget>[
          BottomBar(
            pageCallback: _changePage,
            targetIdx: currentIdx,
          ),
          Container(), // Empty space at the bottom
        ][drawerPages]);
  }
}
