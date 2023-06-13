import 'station.dart';

class Payment {
  double cost;
  String trainID;
  Station from;
  Station to;
  String departureTime;
  String arrivalTime;
  String scheduleDepartureTime;
  String scheduleArrivalTime;
  String date;

  Payment({
    required this.cost,
    required this.trainID,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.scheduleDepartureTime,
    required this.scheduleArrivalTime,
    required this.date,
  });

  factory Payment.fromJson(Map<String, dynamic> data) {
    return Payment(
      cost: data["cost"],
      trainID: data["train_id"],
      from: Station.fromJson(data['from_station']),
      to: Station.fromJson(data['to_station']),
      departureTime: data["departure_time"],
      arrivalTime: data["arrival_time"],
      scheduleDepartureTime: data["scheduled_departure_time"],
      scheduleArrivalTime: data["scheduled_arrival_time"],
      date: data["date"],
    );
  }

  @override
  String toString() {
    return "payment,$cost,$trainID,$from,$to,$departureTime,$arrivalTime,$scheduleDepartureTime,$scheduleArrivalTime,$date";
  }

  factory Payment.fromString(String s) {
    var data = s.split(",");
    return Payment(
      cost: double.parse(data[1]),
      trainID: data[2],
      from: Station.fromString(data[3]),
      to: Station.fromString(data[4]),
      departureTime: data[5],
      arrivalTime: data[6],
      scheduleDepartureTime: data[7],
      scheduleArrivalTime: data[8],
      date: data[9],
    );
  }
}
