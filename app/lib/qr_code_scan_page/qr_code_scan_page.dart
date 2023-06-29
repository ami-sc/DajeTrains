import 'package:flutter/material.dart';
import 'barcode_scanner.dart';

import "qr_code_top_bar.dart";
import "../nav_drawer.dart";

class QRCodePage extends StatefulWidget {
  final NavDrawer appDrawer;

  const QRCodePage({
    required this.appDrawer,
    super.key,
  });

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Disable back button functionality.
      onWillPop: () async => false,
      child: Scaffold(
        appBar: QRCodeTopBar(),
        drawer: widget.appDrawer,
        body: Center(
          child: Column(
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
          ),
        )
      ),
    );
  }
}
