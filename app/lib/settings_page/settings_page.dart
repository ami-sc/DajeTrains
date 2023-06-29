import "package:flutter/material.dart";

import "../nav_drawer.dart";

class SettingsPage extends StatefulWidget {
  final NavDrawer appDrawer;

  const SettingsPage({
    required this.appDrawer,
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: widget.appDrawer,
      body: Center(
        child: Text("Settings Page"),
        ),
    );
  }
}
