import 'package:flutter/material.dart';

class ValidityDialog extends StatelessWidget {
  final String trainCode;

  ValidityDialog(this.trainCode);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFE1F8FF),
      icon: Icon(Icons.mobile_friendly, size: 35, color: Colors.green),
      title: const Text('QR SCANNED', textAlign: TextAlign.center),
      content: Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "This ticket is valid for train ",
              style: TextStyle(color: Colors.black, fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                    text: trainCode,
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 30, 255), fontSize: 24)),
              ],
            ),
          )),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
