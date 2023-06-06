import 'station.dart';

class Position {
  String status;
  String station;
  String train;
  Payment payment;
  String ticket;

  Position({
    required this.status,
    required this.station,
    required this.train,
    required this.payment,
    required this.ticket,
  });

  factory Position.fromJson(Map<String, dynamic> data) {
    return Position(
      status: data["status"],
      station: data["station"],
      train: data['train'],
      payment: Payment.fromJson(data['payment_response']),
      ticket: data['ticket_code'],
    );
  }
}

class Payment {
  double cost;
  String trainID;
  Station departure;
  Station arrival;

  Payment({
    required this.cost,
    required this.trainID,
    required this.departure,
    required this.arrival,
  });

  factory Payment.fromJson(Map<String, dynamic> data) {
    return Payment(
      cost: data["cost"],
      trainID: data["train_id"],
      departure: Station.fromJson(data['from_station']),
      arrival: Station.fromJson(data['to_station']),
    );
  }
}
