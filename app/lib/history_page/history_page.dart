import "package:flutter/material.dart";

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: widget.appDrawer,
      body: Center(
        child: Text("History Page"),
        ),
    );
  }
}
