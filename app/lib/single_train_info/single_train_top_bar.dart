import 'package:DajeTrains/structures/train_info.dart';
import 'package:flutter/material.dart';

class SingleTrainTopBar extends StatefulWidget implements PreferredSizeWidget {
  final TrainInfo trainInfo;

  const SingleTrainTopBar({
    required this.trainInfo,
    super.key,
  });

  @override
  State<SingleTrainTopBar> createState() => _SingleTrainTopBarState();

  @override
  Size get preferredSize => Size.fromHeight(190);
}

class _SingleTrainTopBarState extends State<SingleTrainTopBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFA5E6FB),
      title: Text("Train information"),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: Container(
            color: Color(0xFFC8F1FF),
            child: Text(
              widget.trainInfo.beaconID,
              style: TextStyle(fontSize: 30),
            )),
      ),
    );
  }
}
