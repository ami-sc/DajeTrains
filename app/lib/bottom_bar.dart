import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final Function(int) pageCallback;
  final int activeIdx;

  const BottomBar({
    required this.pageCallback,
    required this.activeIdx,
    super.key,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _activeIdx = 0;

  void _onButtonTap(int idx) {
    setState(() {
      _activeIdx = idx;
      widget.pageCallback(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    // We need this in case we need to update the bottom bar when an external
    // button is pressed. For example, if a "back button" is pressed, we must
    // update the index of the sidebar as well.
    _activeIdx = widget.activeIdx;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),

      child: NavigationBar(
        backgroundColor: Color(0xFFA5E6FB),
        indicatorColor: Color(0xFFDAF2FF),

        onDestinationSelected: _onButtonTap,
        selectedIndex: _activeIdx,

        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.business_center),
            label: "Current Trip",
          ),
          NavigationDestination(
            icon: Icon(Icons.subway),
            label: "Stations",
          ),
          NavigationDestination(
            icon: Icon(Icons.train),
            label: "Trains",
          ),
        ],
      ),
    );
  }
}
