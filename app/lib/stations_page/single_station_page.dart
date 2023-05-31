import 'package:flutter/material.dart';

import "../structures/station.dart";
import "../structures/train.dart";
import "../api/timetable_api.dart";

import "single_station_top_bar.dart";
import '../single_train_info/single_train_page.dart';

class SingleStationPage extends StatefulWidget {
  final Station station;

  const SingleStationPage({
    required this.station,
    super.key,
  });

  @override
  State<SingleStationPage> createState() => _SingleStationPageState();
}

class _SingleStationPageState extends State<SingleStationPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  List<Train> arrivalsList = [];
  List<Train> departuresList = [];

  TimetableApi timetableApi = TimetableApi();

  void _getTimetable(String stationName) async {
    List<Train> arrivalsApi =
        await timetableApi.getArrivalsFromApi(stationName);
    List<Train> departuresApi =
        await timetableApi.getDeparturesFromApi(stationName);

    setState(() {
      arrivalsList = arrivalsApi;
      departuresList = departuresApi;
    });
  }

  @override
  void initState() {
    _getTimetable(widget.station.name);
    _tabController = TabController(
      vsync: this,
      length: 2,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SingleStationTopBar(
        stationName: widget.station.name,
        tabController: _tabController,
      ),
      body: TabBarView(controller: _tabController, children: [
        ListView.separated(
            // Needed to have a line dividing each result.
            separatorBuilder: (context, index) => Divider(
                  color: Color.fromARGB(255, 179, 179, 179),
                  height: 1,
                ),
            itemCount: departuresList.length,
            itemBuilder: (BuildContext context, int index) {
              return TrainButton(
                  destination: departuresList[index].lastStation,
                  id: departuresList[index].id,
                  platform: departuresList[index].platform,
                  time: departuresList[index].scheduledArrivalTime,
                  buttonCallback: _toggleStationPage);
            }),
        ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Color.fromARGB(255, 201, 201, 201),
                  height: 1,
                ),
            itemCount: arrivalsList.length,
            itemBuilder: (BuildContext context, int index) {
              return TrainButton(
                  destination: arrivalsList[index].lastStation,
                  id: arrivalsList[index].id,
                  platform: arrivalsList[index].platform,
                  time: arrivalsList[index].scheduledArrivalTime,
                  buttonCallback: _toggleStationPage);
            }),
      ]),
    );
  }

  void _toggleStationPage(String trainID) {
    // Hide the keyboard, if active.
    FocusManager.instance.primaryFocus?.unfocus();

    // Open the page.
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SingleTrainPage(trainID: trainID)),
    );
  }
}

class TrainButton extends StatelessWidget {
  final String destination;
  final String id;
  final int platform;
  final String time;
  final Function(String) buttonCallback;

  const TrainButton({
    required this.destination,
    required this.id,
    required this.platform,
    required this.time,
    required this.buttonCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Color(0xFFDAF2FF)),
        // Make the highlight shape a square.
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      onPressed: () {
        print("SingleStationPage::Train::onPressed");
        buttonCallback(id);
      },
      icon: Padding(
        padding: EdgeInsets.all(10.0),
        child: Icon(
          Icons.train,
          size: 35,
          color: Color(0xFF000000),
        ),
      ),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            // Left align all text.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                destination,
                style: TextStyle(
                  color: Color(0xFF1D1B20),
                  fontSize: 16,
                ),
              ),
              Text(
                id,
                style: TextStyle(
                  color: Color(0xFF49454F),
                  fontSize: 14,
                ),
              ),
              Text(
                "Platform $platform",
                style: TextStyle(
                  color: Color(0xFF49454F),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF0A7D23),
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
