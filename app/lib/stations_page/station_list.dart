import 'package:flutter/material.dart';

import '../structures/station.dart';

class StationList extends StatefulWidget {
  final List<Station> stationList;

  const StationList({
    required this.stationList,
    super.key,
  });

  @override
  State<StationList> createState() => _StationListState();
}

class _StationListState extends State<StationList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.stationList.length,
      // Build a StationButton per station on the list.
      itemBuilder: (BuildContext context, int index) {
        return StationButton(
          stationName: widget.stationList[index].name,
        );
      },
    );
  }
}

class StationButton extends StatelessWidget {
  final String stationName;

  const StationButton({
    required this.stationName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Color(0xFFB5D7FF)),
      ),
      onPressed: () {
        print("StationList::Station::onPressed");
      },
      icon: Icon(
        Icons.subway,
        color: Color(0xFF0557B7),
      ),
      label: Text(
        stationName,
        style: TextStyle(
          color: Color(0xFF0557B7),
        ),
      ),
    );
  }
}
