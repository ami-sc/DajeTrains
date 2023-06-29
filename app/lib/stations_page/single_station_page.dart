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

      arrivalsList.sort((a, b) => a.scheduledArrivalTime.compareTo(b.scheduledArrivalTime));
      departuresList.sort((a, b) => a.scheduledDepartureTime.compareTo(b.scheduledDepartureTime));
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

  Padding _listHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      "Time",
                      style: TextStyle(fontSize: 14, color: Color(0xFF616161)),
                    ),
                  ),
                ],
              )),
          Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Train",
                    style: TextStyle(fontSize: 14, color: Color(0xFF616161)),
                  )
                ],
              )),
          Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Platform",
                      style: TextStyle(fontSize: 14, color: Color(0xFF616161)),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SingleStationTopBar(
        stationName: widget.station.name,
        tabController: _tabController,
      ),
      body: TabBarView(controller: _tabController, children: [
        departuresList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.train,
                      color: Color.fromARGB(255, 174, 174, 174),
                      size: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "No trains departing",
                        style: TextStyle(
                          color: Color.fromARGB(255, 174, 174, 174),
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                // Needed to have a line dividing each result.
                separatorBuilder: (context, index) {
                  if (index == 0) {
                    return SizedBox
                        .shrink(); // Return an empty SizedBox for the first item
                  }
                  return Divider(
                    color: Color.fromARGB(255, 201, 201, 201),
                    height: 1,
                  );
                },
                itemCount: departuresList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return _listHeader();
                  }
                  return TrainButton(
                      destination: departuresList[index - 1].lastStation,
                      id: departuresList[index - 1].id,
                      platform: departuresList[index - 1].platform,
                      time: departuresList[index - 1].scheduledDepartureTime,
                      delay: departuresList[index - 1].lastDelay,
                      buttonCallback: _toggleStationPage);
                }),
        arrivalsList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.train,
                      color: Color.fromARGB(255, 174, 174, 174),
                      size: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "No trains arriving",
                        style: TextStyle(
                          color: Color.fromARGB(255, 174, 174, 174),
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  if (index == 0) {
                    return SizedBox
                        .shrink(); // Return an empty SizedBox for the first item
                  }
                  return Divider(
                    color: Color.fromARGB(255, 201, 201, 201),
                    height: 1,
                  );
                },
                itemCount: arrivalsList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return _listHeader();
                  }

                  return TrainButton(
                      destination: arrivalsList[index - 1].lastStation,
                      id: arrivalsList[index - 1].id,
                      platform: arrivalsList[index - 1].platform,
                      time: arrivalsList[index - 1].scheduledArrivalTime,
                      delay: arrivalsList[index - 1].lastDelay,
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
  final int delay;
  final Function(String) buttonCallback;

  const TrainButton({
    required this.destination,
    required this.id,
    required this.platform,
    required this.time,
    required this.delay,
    required this.buttonCallback,
    super.key,
  });

  String trainType(String id) {
    switch (id.substring(0, 2)) {
      case "FR":
        return "Frecciarossa";
      case "IC":
        return "InterCity";
      default:
        return "Regionale";
    }
  }

  bool isDelayed(int delay) {
    return delay > 0;
  }

  @override
  Widget build(BuildContext context) {
    var trainType = this.trainType(id);

    return TextButton(
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 3,
                child: isDelayed(delay)
                    ?
                    // If the train is delayed, show the delay.
                    Column(
                        children: [
                          Row(
                            //TODO fix alignment
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 18),
                                child: Text(
                                  DateTime(
                                          DateTime.now().year,
                                          0,
                                          0,
                                          int.parse(time.split(':')[0]),
                                          int.parse(time.split(':')[1]),
                                          0,
                                          0,
                                          0)
                                      .add(Duration(minutes: delay))
                                      .toString()
                                      .substring(11, 16),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 201, 41, 41),
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 37),
                                child: Text(
                                  "+$delay'",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 201, 41, 41),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    :
                    // Otherwise, show the scheduled time.
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 18),
                            child: Text(
                              time,
                              style: TextStyle(
                                color: Color(0xFF0A7D23),
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ],
                      )),
            Expanded(
                flex: 4,
                child: Column(
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
                      "$trainType - $id",
                      style: TextStyle(
                        color: Color(0xFF49454F),
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      color: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFA5E6FB),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Center(
                            child: Text(
                              "$platform",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
