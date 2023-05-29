import 'package:flutter/material.dart';
import 'barcode_scanner.dart';

class QRCodeWidget extends StatefulWidget {
  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Please scan a ticket/pass \n",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            // Medium font weight.
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        BarcodeScannerWithoutController(),
      ],
    );
    ;
  }
}
