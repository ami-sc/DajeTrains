import "package:flutter/material.dart";
import 'single_payment_page.dart';

import "../nav_drawer.dart";

class HistoryPage extends StatefulWidget {
  final NavDrawer appDrawer;

  const HistoryPage({
    required this.appDrawer,
    super.key,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void _togglePaymentPage() {
    // Hide the keyboard, if active.
    FocusManager.instance.primaryFocus?.unfocus();

    // Open the page.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SinglePaymentPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: widget.appDrawer,
      body: Center(
          child: ElevatedButton(
        onPressed: _togglePaymentPage,
        child: Text('Show single payment page'),
      )),
    );
  }
}
