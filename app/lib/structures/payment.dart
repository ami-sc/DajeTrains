import 'dart:ffi';

import 'station.dart';

class Payment {
  double cost;
  String trainID;
  Station from;
  Station to;

  Payment({
    required this.cost,
    required this.trainID,
    required this.from,
    required this.to,
  });

  factory Payment.fromJson(Map<String, dynamic> data) {
    return Payment(
      cost: data["cost"],
      trainID: data["train_id"],
      from: Station.fromJson(data['from_station']),
      to: Station.fromJson(data['to_station']),
    );
  }
}
