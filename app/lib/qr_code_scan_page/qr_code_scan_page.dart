import 'package:flutter/material.dart';

import 'qr_code_top_bar.dart';
import '../nav_drawer.dart';

class QRCodeScan extends StatefulWidget {
  @override
  State<QRCodeScan> createState() => _QRCodeScanState();
}

class _QRCodeScanState extends State<QRCodeScan> {
  int barIdx = 0; // Homepage index

  void _onLabelTap(int newIdx) {
    setState(() {
      barIdx = newIdx;
      print("SideMenu value:");
      print(barIdx);
    });
  }

  @override
  Widget build(BuildContext context) {
    var navBar = NavDrawer(
      targetIdx: 0,
      indexCallback: _onLabelTap,
    );

    return Scaffold(
      appBar: QRCodeTopBar(),
      drawer: navBar,

      // Needed for the round corners of the bottom bar.
      extendBody: true,

      body: Text("Prova"),
    );
  }
}
