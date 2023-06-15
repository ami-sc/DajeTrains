import 'dart:convert';
import 'package:http/http.dart' as http;

class TrainsApi {
  // The URL of the API.
  String apiUrl = "https://dajetrains.srv.mrlc.cc/trains/";

  // Given a query, retrieve a list of trains.
  Future<List<String>> getTrainsFromApi(String query) async {
    // Send query to the API and get HTTP response.
    var response = await http.get(Uri.parse("$apiUrl$query"));

    // If the server returns a 200 (OK) response, decode the JSON.
    if (response.statusCode == 200) {
      print("TrainsApi - Succesful response from API.");
      List<dynamic> trainListJson = jsonDecode(response.body);

      List<String> trainIds = [];

      for(final train in trainListJson) {
        trainIds.add(train["id"]);
      }
      return trainIds;
      // If the server does not return a 200 (OK) reponse, return an empty list.
    } else {
      print("TrainsApi - Invalid response from API.");
      return [];
    }
  }
}
