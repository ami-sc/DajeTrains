import 'station.dart';

class TrainInfo {
  String ID;
  String beaconID;
  int lastDelay;
  List<TripStation> trip;

  TrainInfo(
      {required this.ID,
      required this.beaconID,
      required this.lastDelay,
      required this.trip});

  factory TrainInfo.fromJson(Map<String, dynamic> data) {
    return TrainInfo(
        ID: data["id"],
        lastDelay: data["last_delay"],
        beaconID: data["beacon_id"],
        trip: List<TripStation>.from(
            data["trip"].map((trainTrip) => TripStation.fromJson(trainTrip))));
  }
}

class TripStation {
  Station station;
  String scheduledArrivalTime;
  String scheduledDepartureTime;
  String arrivalTime;
  String departureTime;
  int platform;
  double cost;

  TripStation(
      {required this.station,
      required this.scheduledArrivalTime,
      required this.scheduledDepartureTime,
      required this.arrivalTime,
      required this.departureTime,
      required this.platform,
      required this.cost});

  factory TripStation.fromJson(Map<String, dynamic> data) {
    double cost = 0.0;
    if (data["cost"] != 0) {
      cost = data["cost"];
    }
    return TripStation(
        station: Station.fromJson(data["station"]),
        scheduledArrivalTime: data["scheduled_arrival_time"],
        scheduledDepartureTime: data["scheduled_departure_time"],
        arrivalTime: data["arrival_time"],
        departureTime: data["departure_time"],
        platform: data["platform"],
        cost: cost);
  }

  bool hasArrived() {
    return arrivalTime != "";
  }

  bool hasDeparted() {
    return departureTime != "";
  }
}
