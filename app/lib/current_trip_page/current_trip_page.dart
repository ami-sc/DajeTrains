import 'package:flutter/material.dart';

class CurrentTripPage extends StatefulWidget {
  @override
  State<CurrentTripPage> createState() => _CurrentTripPageState();
}

class _CurrentTripPageState extends State<CurrentTripPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: MainImage(),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 100.0),
          child: MainText(),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: FindButton(),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 50.0),
          child: HistoryButton(),
        ),
      ],
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
        )
      ),
    );
  }
}
