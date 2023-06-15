import 'payment.dart';

class Position {
  String status;
  String id;
  Payment? payment;
  String ticket;

  Position({
    required this.status,
    required this.id,
    required this.payment,
    required this.ticket,
  });

  factory Position.fromJson(Map<String, dynamic> data) {
    if (data['payment_response'] != null) {
      return Position(
        status: data["status"],
        id: data['id'],
        payment: Payment.fromJson(data['payment_response']),
        ticket: data['ticket_code'],
      );
    } else {
      return Position(
        status: data["status"],
        id: data['id'],
        payment: null,
        ticket: data['ticket_code'],
      );
    }
  }

  @override
  String toString() {
    return "$id,$status,$payment,$ticket";
  }
}

/*class Payment {
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
}*/
