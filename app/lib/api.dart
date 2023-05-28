import 'dart:convert';
import 'package:http/http.dart' as http;

import "structures/station.dart";

class StationsApi {
  // The URL of the API.
  String apiUrl = "https://dajetrains.srv.mrlc.cc/stations/";
  // A list to hold the retrieved stations.
  List<Station> stationList = [];

  // Given a query, retrieve a list of stations.
  Future<List<Station>> getStationsFromApi(String query) async {
    // Send query to the API and get HTTP response.
    var response = await http.get(Uri.parse("$apiUrl$query"));

    // If the server returns a 200 (OK) response, decode the JSON.
    if (response.statusCode == 200) {
      print("StationsAPI - Succesful response from API.");
      List<dynamic> stationListJson = jsonDecode(response.body);
      return stationListJson.map(
        (stationObj) => Station.fromJson(stationObj)).toList();
    // If the server does not return a 200 (OK) reponse, return an empty list.
    } else {
      print("StationsAPI - Invalid response from API.");
      return [];
    }
  }
}
