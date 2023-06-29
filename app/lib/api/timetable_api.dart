import 'dart:convert';
import 'package:http/http.dart' as http;

import '../structures/train.dart';

class TimetableApi {
  // The URL of the API.
  String apiUrl = "https://dajetrains.srv.mrlc.cc/stations/";
  // A list to hold the retrieved stations.
  List<Train> stationList = [];

  // Given a station, retrieve the list of departures.
  Future<List<Train>> getDeparturesFromApi(String station) async {
    // Send query to the API and get HTTP response.
    var response = await http.get(Uri.parse("$apiUrl$station/departures"));

    // If the server returns a 200 (OK) response, decode the JSON.
    if (response.statusCode == 200) {
      print("TimetableApi - Succesful response from API.");
      List<dynamic> departuresListJson = jsonDecode(response.body);
      return departuresListJson
          .map((trainObj) => Train.fromJson(trainObj))
          .toList();
      // If the server does not return a 200 (OK) reponse, return an empty list.
    } else {
      print("TimetableApi - Invalid response from API.");
      return [];
    }
  }

  // Given a station, retrieve the list of arrivals.
  Future<List<Train>> getArrivalsFromApi(String station) async {
    // Send query to the API and get HTTP response.
    var response = await http.get(Uri.parse("$apiUrl$station/arrivals"));

    // If the server returns a 200 (OK) response, decode the JSON.
    if (response.statusCode == 200) {
      print("TimetableApi - Succesful response from API.");
      List<dynamic> departuresListJson = jsonDecode(response.body);
      return departuresListJson
          .map((trainObj) => Train.fromJson(trainObj))
          .toList();
      // If the server does not return a 200 (OK) reponse, return an empty list.
    } else {
      print("TimetableApi - Invalid response from API.");
      return [];
    }
  }
}
