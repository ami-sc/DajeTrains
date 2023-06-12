import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CurrentTripPageOnBoard extends StatefulWidget {
  @override
  State<CurrentTripPageOnBoard> createState() => _CurrentTripPageOnBoardState();
}

class _CurrentTripPageOnBoardState extends State<CurrentTripPageOnBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SlidingUpPanelExample"),
      ),
      body: SlidingUpPanel(
        minHeight: 150,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
        ),
        panel: Center(
          child: Text("This is the sliding Widget"),
        ),
        body: Center(
          child: Text("This is the Widget behind the sliding panel"),
        ),
      ),
    );
  }
}

class MainImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 325,
      child: Image(
        image: AssetImage('assets/train.png'),
      ),
    );
  }
}

class MainText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Text(
        "You are not currently riding a train!",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32,
          // Medium font weight.
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
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
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Color(0xFFB5D7FF)),
      ),
      child: Text("View History",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF0557B7),
            // Medium font weight.
            fontWeight: FontWeight.w500,
          )),
    );
  }
}
