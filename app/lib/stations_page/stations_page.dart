import 'package:flutter/material.dart';

import "station_list.dart";
import "../structures/station.dart";

class StationsPage extends StatefulWidget {
  final List<Station> stationList;

  const StationsPage({
    required this.stationList,
    super.key,
  });

  @override
  State<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> {
  @override
  Widget build(BuildContext context) {
    return StationList (
      stationList: widget.stationList,
    );
  }
}
