import "package:flutter/material.dart";

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

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _drawerIdx = 0;
  int _activePageIdx = 0;
  int _previousPageIdx = 0;
  bool _topBarState = true;
  bool _bottomBarState = true;
  PageController _pageControl = PageController(initialPage: 0);

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

      bottomNavigationBar: _bottomBarState ? BottomBar(
        pageCallback: _changePage,
        activeIdx: _activePageIdx,
      ) : null,
    );
  }
}
