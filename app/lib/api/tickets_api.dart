import 'dart:convert';
import 'package:http/http.dart' as http;

class TicketsApi {
  // The URL of the API.
  String apiUrl = "https://dajetrains.srv.mrlc.cc/tickets/";

  // Given a query, check if the ticket is valid
  Future<String> isValid(String? code) async {
    if (code == null) {
      return "";
    }

    // Send query to the API and get HTTP response.
    var response = await http.get(Uri.parse("$apiUrl$code"));

    // If the server returns a 200 (OK) response, then the ticket is valid
    if (response.statusCode == 200) {
      print("TicketsAPI - Succesful response from API.");
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      return responseJson['train_id'];
      // If the server does not return a 200 (OK) reponse, return an empty list.
    } else {
      print("TrainsAPI - Invalid response from API.");
      // The ticket is not valid
      return "";
    }
  }
}
