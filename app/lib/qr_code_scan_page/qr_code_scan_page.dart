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
        BarcodeScannerWithoutController(),
      ],
    );
    ;
  }
}
