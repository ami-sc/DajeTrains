import 'package:flutter/material.dart';

class SingleStationTopBar extends StatefulWidget implements PreferredSizeWidget {
  final String stationName;
  final TabController tabController;

  const SingleStationTopBar({
    required this.stationName,
    required this.tabController,
    super.key,
  });

  @override
  State<SingleStationTopBar> createState() => _SingleStationTopBarState();

  @override
  Size get preferredSize => Size.fromHeight(100);
}

class _SingleStationTopBarState extends State<SingleStationTopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFA5E6FB),
      title: Text(widget.stationName),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: TabBar(
          controller: widget.tabController,
          tabs: [
            Tab(text: "Departures"),
            Tab(text: "Arrivals"),
          ],
        ),
      ),
    );
  }
}
