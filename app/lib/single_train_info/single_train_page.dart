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
}

class _SingleTrainPageState extends State<SingleTrainPage>
    with TickerProviderStateMixin {
  bool _defaultMessage = true;

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
            : SingleTrainTripTopBar(trainInfo: trainInfo!),
        body: _defaultMessage
            ? null
            : Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                child: ListView.builder(
                    itemCount: trainInfo!.trip.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Expanded(flex: 2, child: SizedBox.shrink()),

                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [ Text(
                                    "Stops",
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xFF616161)),
                                  )],
                                )
                              ),
                              
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [ Text(
                                    "Platform",
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xFF616161)),
                                  )],
                                )
                              )
                            ],
                          ),
                        );
                      }
                      return _TripStationView(
                          tripStation: trainInfo!.trip[index - 1],
                          notLast: index - 1 < trainInfo!.trip.length - 1);
                    }),
              ));
  }
}

class _TripStationView extends StatelessWidget {
  final TripStation tripStation;
  final bool notLast;

  const _TripStationView({required this.tripStation, required this.notLast});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tripStation.hasArrived()
                      ? Text("Arrival:")
                      : Text("Expected arrival:"),
                  Text(
                    tripStation.scheduledArrivalTime,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tripStation.hasDeparted()
                      ? Text("Departure:")
                      : Text("Expected departure:"),
                  Text(
                    tripStation.scheduledDepartureTime,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
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
                                : Color.fromARGB(255, 204, 204, 204),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Center(
                          child: Text(
                            "${tripStation.platform}",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
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
