import 'dart:convert';
import 'package:http/http.dart' as http;
import '../structures/position.dart';
import '../globals.dart' as globals;

class PositionApi {
  final String beaconID;

  PositionApi({
    required this.beaconID,
  });

  // The URL of the API.
  String apiUrl = "https://dajetrains.srv.mrlc.cc/positions/";

  Future<Position> updatePosition() async {
    var user = globals.username;
    var response =
        await http.put(Uri.parse("$apiUrl$user?beacon_id=$beaconID"));

    if (response.statusCode == 200) {
      print("PositionAPI - Succesful response from API.");
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      return Position.fromJson(responseJson);
    } else {
      print("PositionAPI - Invalid response from API.");
      // Throw an error
      throw Exception('Failed to load position');
    }
  }
}
