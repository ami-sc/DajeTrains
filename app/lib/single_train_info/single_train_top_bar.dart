import 'package:DajeTrains/structures/train_info.dart';
import 'package:DajeTrains/history_page/single_payment_top_bar.dart';
import 'package:flutter/material.dart';

class SingleTrainTripTopBar extends StatefulWidget
    implements PreferredSizeWidget {
  final TrainInfo trainInfo;
  final bool delayed;

  const SingleTrainTripTopBar({
    required this.trainInfo,
    required this.delayed,
    super.key,
  });

  @override
  State<SingleTrainTripTopBar> createState() => _SingleTrainTripTopBarState();

  @override
  Size get preferredSize => Size.fromHeight(165);
}

class _SingleTrainTripTopBarState extends State<SingleTrainTripTopBar> {

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

                Expanded(
                  flex: 2,
                  child: Column(// Logo
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: SingleTrainTopBar.logoColor(
                                      widget.trainInfo.ID),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0))),
                              child: Center(
                                child: Text(
                                  SingleTrainTopBar.trainAbbrev(
                                      widget.trainInfo.ID),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        ),
                      ),
                    ]
                  )
                ),

                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Info
                    children: [
                      Row(
                        children: [
                          Text(widget.trainInfo.ID,
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          widget.trainInfo.trip[0].hasDeparted()?
                          Text(
                              // partito
                              widget.trainInfo.trip[0].departureTime,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF49454F),
                                  fontWeight: FontWeight.bold))
                          :
                          Text(
                              // non partito
                              widget.trainInfo.trip[0].scheduledDepartureTime,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: widget.delayed? Colors.red : Color(0xFF49454F),
                                  fontWeight: FontWeight.bold)
                          ),

                          Text(" ${widget.trainInfo.trip[0].station.name}",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF49454F)))
                        ],
                      ),
                      Row(
                        children: [
                          widget.trainInfo.trip[widget.trainInfo.trip.length - 1].hasArrived() ?
                          Text(
                              // arrivato
                              widget
                                  .trainInfo
                                  .trip[widget.trainInfo.trip.length - 1]
                                  .arrivalTime,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF49454F),
                                  fontWeight: FontWeight.bold))
                          :
                          Text(
                            // non arrivato
                              widget
                                  .trainInfo
                                  .trip[widget.trainInfo.trip.length - 1]
                                  .scheduledArrivalTime,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: widget.delayed? Colors.red : Color(0xFF49454F),
                                  fontWeight: FontWeight.bold)),
                          
                          Text(
                              " ${widget.trainInfo.trip[widget.trainInfo.trip.length - 1].station.name}",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF49454F)))
                        ],
                      ),
                    ],
                  )
                ),

                Expanded(
                  flex: 3,
                  child: Column(// Delay
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.all(15.0),
                        child: widget.delayed
                        ? Container(
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                "+${widget.trainInfo.lastDelay}'",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : null
                      ),
                    ]
                  )
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
