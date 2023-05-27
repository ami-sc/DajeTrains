import 'package:flutter/material.dart';

class CurrentTrip extends StatefulWidget {
  @override
  State<CurrentTrip> createState() => _CurrentTripState();
}

class _CurrentTripState extends State<CurrentTrip> {
  @override
  Widget build(BuildContext context) {
    return Column(
        // Center widgets.
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MainText(),
        FindButton(),
        HistoryButton(),
      ]
    );
  }
}

class MainText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "You are not currently riding a train!",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        // Medium font weight.
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class FindButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 57,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFB5D7FF),
          foregroundColor: Color(0xFF000000),
          elevation: 4,
        ),
        icon: Icon(Icons.train),
        label: Text(
          "Find a Train",
          style: TextStyle(
            fontSize: 20,
            // Medium font weight.
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () {
          print("CurrentTrip::FindButton::onPressed");
        },
      ),
    );
  }
}

class HistoryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print("CurrentTrip::HistoryButton::onPressed");
      },
      child: Text("View History",
        style: TextStyle(
          fontSize: 18,
          color: Color(0xFF0557B7),
          // Medium font weight.
          fontWeight: FontWeight.w500,
        )
      ),
    );
  }
}
