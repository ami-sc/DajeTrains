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
}
