import 'package:DajeTrains/structures/train_info.dart';
import 'package:DajeTrains/history_page/single_payment_top_bar.dart';
import 'package:flutter/material.dart';

class SingleTrainTripTopBar extends StatefulWidget implements PreferredSizeWidget {
  final TrainInfo trainInfo;

  const SingleTrainTripTopBar({
    required this.trainInfo,
    super.key,
  });

  @override
  State<SingleTrainTripTopBar> createState() => _SingleTrainTripTopBarState();

  @override
  Size get preferredSize => Size.fromHeight(190);
}

class _SingleTrainTripTopBarState extends State<SingleTrainTripTopBar> {

  bool delayed = false;

  @override
  void initState() {
    delayed = (widget.trainInfo.lastDelay > 0)? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFA5E6FB),
      title: Text("Train information"),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(182, 200, 241, 255),
            border: Border(
              bottom: BorderSide(width: 1.0, color: Color(0xFFCAC4D0)),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(// Logo
                    children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      color: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
                              color: SingleTrainTopBar.logoColor(widget.trainInfo.ID),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          child: Center(
                            child: Text(
                              SingleTrainTopBar.trainAbbrev(widget.trainInfo.ID),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                  ),
                ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Info
                  children: [
                    Row(
                      children: [
                        Text(widget.trainInfo.ID, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: [
                        Text( // TODO applicare ritardo
                          widget.trainInfo.trip[0].scheduledDepartureTime,
                          style: TextStyle(fontSize: 14, color: delayed? Colors.red : Color(0xFF49454F), fontWeight: FontWeight.bold)
                        ),
                        Text(
                           " ${widget.trainInfo.trip[0].station.name}",
                          style: TextStyle(fontSize: 14, color: Color(0xFF49454F))
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text( // TODO applicare ritardo
                          widget.trainInfo.trip[widget.trainInfo.trip.length - 1].scheduledArrivalTime,
                          style: TextStyle(fontSize: 14, color: delayed? Colors.red : Color(0xFF49454F), fontWeight: FontWeight.bold)
                        ),
                        Text(
                           " ${widget.trainInfo.trip[widget.trainInfo.trip.length - 1].station.name}",
                          style: TextStyle(fontSize: 14, color: Color(0xFF49454F))
                        )
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Column(// Delay
                    children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 40.0, 15.0),
                      child: delayed
                      ? Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            "+${widget.trainInfo.lastDelay}'", 
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.red,
                                fontWeight: FontWeight.w600
                              ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                      : null
                    ),
                  ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
