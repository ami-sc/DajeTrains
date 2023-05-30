import 'package:flutter/material.dart';

class CurrentTripTopBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<CurrentTripTopBar> createState() => _CurrentTripTopBarState();

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _CurrentTripTopBarState extends State<CurrentTripTopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Color(0xFFA5E6FB),
        title: Text("DajeTrains"),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Icon(Icons.account_circle_rounded),
          ),
        ]);
  }
}
