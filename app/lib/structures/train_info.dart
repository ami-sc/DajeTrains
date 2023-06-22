import 'station.dart';
import 'package:quiver/core.dart';
import 'package:collection/collection.dart';

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

  @override
  bool operator ==(Object other) {
    if (other is TrainInfo) {
      Function eq = const ListEquality().equals;
      if (ID == other.ID &&
          beaconID == other.beaconID &&
          lastDelay == other.lastDelay &&
          eq(trip, other.trip)) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => hash4(ID, beaconID, lastDelay, trip);

  int lastArrivedStation() {
    for (var i = trip.length - 1; i >=0 ; i--) {
      if (trip[i].hasArrived()) return i;
    }
    return 0;
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

  @override
  bool operator ==(Object other) {
    if (other is TripStation) {
      if (station == other.station &&
          scheduledArrivalTime == other.scheduledArrivalTime &&
          scheduledDepartureTime == other.scheduledDepartureTime &&
          arrivalTime == other.arrivalTime &&
          departureTime == other.departureTime &&
          platform == other.platform &&
          cost == other.cost) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => hashObjects([
        station,
        scheduledArrivalTime,
        scheduledDepartureTime,
        arrivalTime,
        departureTime,
        platform,
        cost
      ]);
}
