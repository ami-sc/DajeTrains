import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFCEF3FF),
        width: double.infinity,
        height: 89,
        padding: EdgeInsets.only(top: 20.0, left: 20.0),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'DajeTrains',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF49454F), fontSize: 25),
            )));
  }
}
