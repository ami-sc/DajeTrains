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
  TrainInfo? trainInfo; //TODO make it nullable TrainInfo


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
        child: Text(trainInfo!.beaconID),
      )
    );
  }
}
