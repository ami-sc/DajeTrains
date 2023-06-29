import 'package:flutter/material.dart';

class TrainList extends StatefulWidget {
  final List<String> trainList;
  final Function(String) trainCallback;

  const TrainList({
    required this.trainList,
    required this.trainCallback,
    super.key,
  });

  @override
  State<TrainList> createState() => _TrainListState();
}

class _TrainListState extends State<TrainList> {
  void _trainButtonPress(int trainIdx) {
    widget.trainCallback(widget.trainList[trainIdx]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.trainList.length,
      // Build a StationButton per station on the list.
      itemBuilder: (BuildContext context, int index) {
        return TrainButton(
          trainId: widget.trainList[index],
          listIdx: index,
          buttonCallback: _trainButtonPress,
        );
      },
    );
  }
}

class TrainButton extends StatelessWidget {
  final String trainId;
  final int listIdx;
  final Function(int) buttonCallback;

  const TrainButton({
    required this.trainId,
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
          print("TrainList::Train::onPressed");
          // Return the index (according to the TrainList) of the Train.
          buttonCallback(listIdx);
        },
        icon: Icon(
          Icons.train_sharp,
          color: Color.fromARGB(255, 55, 62, 71),
          size: 28,
        ),
        label: Text(
          trainId,
          style: TextStyle(
            color: Color.fromARGB(255, 55, 62, 71),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
