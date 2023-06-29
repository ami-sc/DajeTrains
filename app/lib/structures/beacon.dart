class Beacon {
  String name;
  String uuid;
  String rssi;

  Beacon({
    required this.name,
    required this.uuid,
    required this.rssi,
  });

  factory Beacon.fromString(String data) {
    data = data.replaceAll("{", "");
    data = data.replaceAll("}", "");
    data = data.replaceAll("\"", "");
    data = data.replaceAll(" ", "");
    List<String> splitted = data.split(",");
    // Now the list is like this:
    // [name: , uuid: , macAddress: , major: , minor: , disatnce: , proximity: , scantime: , rssi: , txPower: ]
    return Beacon(
        name: splitted[0].split(":")[1],
        uuid: splitted[1].split(":")[1],
        rssi: splitted[8].split(":")[1]);
  }
}
