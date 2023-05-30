class Train {
  String id;
  String scheduledArrivalTime;
  String scheduledDepartureTime;
  String firstStation;
  String lastStation;
  int lastDelay;
  int platform;

  Train({
    required this.id,
    required this.scheduledArrivalTime,
    required this.scheduledDepartureTime,
    required this.firstStation,
    required this.lastStation,
    required this.lastDelay,
    required this.platform,
  });

  factory Train.fromJson(Map<String, dynamic> data) {
    return Train(
      id: data["train_id"],
      scheduledArrivalTime: data["scheduled_arrival_time"],
      scheduledDepartureTime: data["scheduled_departure_time"],
      firstStation: data["first_station"],
      lastStation: data["last_station"],
      lastDelay: data["last_delay"],
      platform: data["platform"],
    );
  }
}
