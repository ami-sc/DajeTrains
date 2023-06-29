import 'package:DajeTrains/structures/train.dart';
import 'package:flutter/material.dart';
import "single_train_top_bar.dart";
import 'package:DajeTrains/api/trip_api.dart';
import 'package:DajeTrains/structures/train_info.dart';
import 'package:dotted_line/dotted_line.dart';

class SingleTrainPage extends StatefulWidget {
  final String trainID;

  const SingleTrainPage({
    required this.trainID,
    super.key,
  });

  @override
  State<SingleTrainPage> createState() => _SingleTrainPageState();

  static Widget trainRoute(TrainInfo trainInfo, bool delayed,
      [int first = 0, ScrollController? scrollController]) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
      child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: trainInfo.trip.length - first + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 2, child: SizedBox.shrink()),
                          Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stops",
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xFF616161)),
                                  )
                                ],
                              )),
                          Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Platform",
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xFF616161)),
                                  )
                                ],
                              ))
                        ],
                      )),
                  (first > 0)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DottedLine(
                                          dashColor: Color(0xFFA5E6FB),
                                          direction: Axis.vertical,
                                          dashLength: 5,
                                          lineThickness: 5,
                                          dashGapLength: 2,
                                          dashRadius: 80,
                                          lineLength: 30,
                                        )
                                      ],
                                    ))),
                            Expanded(flex: 5, child: SizedBox.shrink()),
                            Expanded(flex: 3, child: SizedBox.shrink())
                          ],
                        )
                      : Row(),
                ],
              );
            }
            return TripStationView(
              tripStation: trainInfo.trip[first + index - 1],
              notLast: first + index - 1 < trainInfo.trip.length - 1,
              notFirst: first + index - 1 > 0,
              delayed: delayed,
              delay: trainInfo.lastDelay,
            );
          }),
    );
  }
}

class _SingleTrainPageState extends State<SingleTrainPage>
    with TickerProviderStateMixin {
  bool _defaultMessage = true;
  bool _delayed = false;

  TripApi api = TripApi();
  TrainInfo? trainInfo;

  @override
  void initState() {
    _getTrainInfo();
    super.initState();
  }

  void _getTrainInfo() async {
    List<TrainInfo> l = await api.getTrip(widget.trainID);
    print(l);

    if (l.isNotEmpty) {
      setState(() {
        trainInfo = l[0];
        _defaultMessage = false;
        _delayed =
            (trainInfo!.lastDelay > 0) ? true : false; // CHANGE FOR DEBBUGGING
      });
    } else {
      throw Exception("Non valid Train ID");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _defaultMessage
            ? null
            : SingleTrainTripTopBar(
                trainInfo: trainInfo!,
                delayed: _delayed,
              ),
        body: _defaultMessage
            ? null
            : SingleTrainPage.trainRoute(trainInfo!, _delayed));
  }
}

class TripStationView extends StatelessWidget {
  final TripStation tripStation;
  final int delay;
  final bool notLast;
  final bool notFirst;
  final bool delayed;

  const TripStationView(
      {required this.tripStation,
      required this.notLast,
      required this.notFirst,
      required this.delayed,
      required this.delay});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Column(// Dots
                  children: [
                Icon(
                  tripStation.hasArrived()
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: tripStation.hasArrived()
                      ? Color(0xFFA5E6FB)
                      : Colors.grey,
                  size: 25,
                ),
                notLast
                    ? DottedLine(
                        dashColor: tripStation.hasDeparted()
                            ? Color(0xFFA5E6FB)
                            : Colors.grey,
                        direction: Axis.vertical,
                        dashLength: 5,
                        lineThickness: 5,
                        dashGapLength: 2,
                        dashRadius: 80,
                        lineLength: 60,
                      )
                    : SizedBox.shrink(),
              ])),
        ),
        Expanded(
          flex: 5,
          child: Column(
            // Info
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tripStation.station.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              notFirst
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tripStation.hasArrived()
                            ? Text("Arrival:")
                            : Text("Expected arrival:"),
                        tripStation.hasArrived()
                            ? Text(
                                tripStation.arrivalTime,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : Text(
                                Train.addDelay(
                                    tripStation.scheduledArrivalTime, delay),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: delayed
                                        ? Colors.red
                                        : Color(0xFF49454F)),
                              )
                      ],
                    )
                  : Row(),
              notLast
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tripStation.hasDeparted()
                            ? Text("Departure:")
                            : Text("Expected departure:"),
                        tripStation.hasDeparted()
                            ? Text(
                                tripStation.departureTime,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : Text(
                                Train.addDelay(
                                    tripStation.scheduledDepartureTime, delay),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: delayed
                                        ? Colors.red
                                        : Color(0xFF49454F)),
                              )
                      ],
                    )
                  : Row(),
            ],
          ),
        ),
        Expanded(
            flex: 3,
            child: Column(
              // Platform
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            color: tripStation.hasArrived()
                                ? Color(0xFFA5E6FB)
                                : Color(0xFF757575),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Center(
                          child: Text(
                            "${tripStation.platform}",
                            style: TextStyle(
                                fontSize: 24,
                                color: tripStation.hasArrived()
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
