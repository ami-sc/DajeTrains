import 'package:flutter/material.dart';

class HistoryTopBar extends StatefulWidget implements PreferredSizeWidget {

  @override
  State<HistoryTopBar> createState() => _HistoryTopBarState();

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _HistoryTopBarState extends State<HistoryTopBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Color(0xFFA5E6FB),
        title: Text("History"),
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
