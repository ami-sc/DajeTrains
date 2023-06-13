import 'station.dart';

class TrainInfo {
  String ID;
  String beaconID;
  int lastDelay;
  List<_TripStation> trip;

  TrainInfo({
    required this.ID,
    required this.beaconID,
    required this.lastDelay,
    required this.trip
  });

  factory TrainInfo.fromJson(Map<String, dynamic> data) {
    return TrainInfo(
      ID: data["id"],
      lastDelay: data["last_delay"],
      beaconID: data["beacon_id"],
      trip: List<_TripStation>.from(data["trip"]
                                    .map((trainTrip) => _TripStation.fromJson(trainTrip))
      )
    );
  }
}

class _TripStation {
  Station station;
  String scheduledArrivalTime;
  String scheduledDepartureTime;
  int platform;
  double cost;

  _TripStation({
    required this.station,
    required this.scheduledArrivalTime,
    required this.scheduledDepartureTime,
    required this.platform,
    required this.cost
  });

  factory _TripStation.fromJson(Map<String, dynamic> data) {
    double cost = 0.0;
    if (data["cost"] != 0) {
      cost = data["cost"];
    }
    return _TripStation(
      station: Station.fromJson(data["station"]),
      scheduledArrivalTime: data["scheduled_arrival_time"],
      scheduledDepartureTime: data["scheduled_departure_time"],
      platform: data["platform"],
      cost: cost
    );
  }

}
