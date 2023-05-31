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
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(
          endIndent: 40,
          indent: 40,
        );
      },
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
        height: 70,
        child: TextButton.icon(
          style: ButtonStyle(
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
            color: Color(0xFF0557B7),
            size: 28,
          ),
          label: Text(
            stationName,
            style: TextStyle(
              color: Color(0xFF0557B7),
              fontSize: 18,
            ),
          ),
        ));
  }
}
