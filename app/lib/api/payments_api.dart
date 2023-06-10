import 'dart:convert';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

import '../structures/payment.dart';

class PaymentsApi {
  // Retrieve a list of payments.
  static Future<List<Payment>> getPaymentsHistory() async {
    // The URL of the API.
    String apiUrl = "https://dajetrains.srv.mrlc.cc/payment_history/";
    // Send query to the API and get HTTP response.
    var username = globals.username;
    var response = await http.get(Uri.parse("$apiUrl$username"));

    // If the server returns a 200 (OK) response, decode the JSON.
    if (response.statusCode == 200) {
      print("StationsAPI - Succesful response from API.");
      List<dynamic> paymentsListJson = jsonDecode(response.body);
      return paymentsListJson
          .map((paymentObj) => Payment.fromJson(paymentObj))
          .toList();
      // If the server does not return a 200 (OK) reponse, return an empty list.
    } else {
      print("StationsAPI - Invalid response from API.");
      return [];
    }
  }
}
