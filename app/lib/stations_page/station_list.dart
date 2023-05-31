import 'package:flutter/material.dart';

import '../structures/station.dart';

class StationList extends StatefulWidget {
  final List<Station> stationList;
  final Function(Station) stationCallback;

  const StationList({
    required this.stationList,
    required this.stationCallback,
    super.key,
  });

  @override
  State<StationList> createState() => _StationListState();
}

class _StationListState extends State<StationList> {
  void _stationButtonPress(int stationIdx) {
    widget.stationCallback(widget.stationList[stationIdx]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.stationList.length,
      // Build a StationButton per station on the list.
      itemBuilder: (BuildContext context, int index) {
        return StationButton(
          stationName: widget.stationList[index].name,
          listIdx: index,
          buttonCallback: _stationButtonPress,
        );
      },
    );
  }
}

class StationButton extends StatelessWidget {
  final String stationName;
  final int listIdx;
  final Function(int) buttonCallback;

  const StationButton({
    required this.stationName,
    required this.listIdx,
    required this.buttonCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextButton.icon(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.fromLTRB(30, 10, 0, 0),
          ),
          alignment: Alignment.centerLeft,
          overlayColor: MaterialStateProperty.all(Color(0xFFB5D7FF)),
          // Make the highlight shape a square.
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        onPressed: () {
          print("StationList::Station::onPressed");
          // Return the index (according to the StationList) of the Station.
          buttonCallback(listIdx);
        },
        icon: Icon(
          Icons.subway_outlined,
          color: Color.fromARGB(255, 55, 62, 71),
          size: 28,
        ),
        label: Text(
          stationName,
          style: TextStyle(
            color: Color.fromARGB(255, 55, 62, 71),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
