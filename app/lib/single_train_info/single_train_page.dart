import 'package:flutter/material.dart';
import "single_train_top_bar.dart";
import 'package:DajeTrains/api/trip_api.dart';
import 'package:DajeTrains/structures/train_info.dart';

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
      : SingleTrainTopBar(trainInfo: trainInfo!),
      body: _defaultMessage
      ? Container(child: Text("empty"),)
      : Container(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                  color: Color.fromARGB(255, 179, 179, 179),
                  height: 1,
                ),
            itemCount: trainInfo!.trip.length,
            itemBuilder: (BuildContext context, int index) {
              return _TripStationView(tripStation: trainInfo!.trip[index]);
            }
          )
      )
    );
  }
}

class _TripStationView extends StatelessWidget {

  final TripStation tripStation;

  const _TripStationView({
    required this.tripStation,
  });

  @override
  Widget build(BuildContext context) {
    return Text(tripStation.station.name);
  }

}
