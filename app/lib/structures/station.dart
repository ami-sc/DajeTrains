import 'package:quiver/core.dart';

class Station {
  String name;
  String beaconId;
  Location location;

  Station({
    required this.name,
    required this.beaconId,
    required this.location,
  });

  factory Station.fromJson(Map<String, dynamic> data) {
    return Station(
      name: data["name"],
      beaconId: data["beacon_id"],
      location: Location.fromJson(data['location']),
    );
  }

  @override
  String toString() {
    return "$name:$beaconId:$location";
  }

  factory Station.fromString(String s) {
    var data = s.split(":");
    return Station(
      name: data[0],
      beaconId: data[1],
      location: Location.fromString(data[2]),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is Station) {
      if (name == other.name &&
          beaconId == other.beaconId &&
          location == other.location) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => hash3(name, beaconId, location);
}

class Location {
  final double latitude;
  final double longitude;

  const Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> data) {
    return Location(
      latitude: data["latitude"],
      longitude: data["longitude"],
    );
  }

  @override
  String toString() {
    return "$latitude;$longitude";
  }

  factory Location.fromString(String s) {
    var data = s.split(";");
    return Location(
      latitude: double.parse(data[0]),
      longitude: double.parse(data[1]),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is Location) {
      if (latitude == other.latitude && longitude == other.longitude) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => hash2(latitude, longitude);
}
