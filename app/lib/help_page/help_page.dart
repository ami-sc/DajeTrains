import "package:flutter/material.dart";

import "../nav_drawer.dart";

class HelpPage extends StatefulWidget {
  final NavDrawer appDrawer;

  const HelpPage({
    required this.appDrawer,
    super.key,
  });

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: widget.appDrawer,
      body: Center(
        child: Text("Help Page"),
        ),
    );
  }
}
