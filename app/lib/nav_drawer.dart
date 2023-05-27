import 'package:flutter/material.dart';
import 'drawer_header.dart';

class NavDrawer extends StatefulWidget {
  final Function(int) indexCallback;

  @override
  State<NavDrawer> createState() => _NavDrawerState();

  const NavDrawer({
    required this.indexCallback,
    super.key,
  });
}

class _NavDrawerState extends State<NavDrawer> {
  int currentIdx = 0;

  void _onLabelTap(int idx) {
    setState(() {
      currentIdx = idx;
      widget.indexCallback(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFCEF3FF),
      child: SingleChildScrollView(
          child: Container(
        child: Column(children: [
          MyHeaderDrawer(),
          MyDrawerList(),
        ]),
      )),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15.0, right: 30, left: 30),
      child: Column(children: [
        // Show the list of menu drawer
        menuItem(1, "Homepage", true),
        menuItem(2, "History", false),
        menuItem(3, "Scan ticket/pass", false),
        menuItem(4, "Settings", false),
        menuItem(5, "Need help?", false),
      ]),
    );
  }

  Widget menuItem(int id, String title, bool selected) {
    return Material(
        borderRadius: BorderRadius.circular(50),
        color: selected ? Color(0xFF97ECFF) : Colors.transparent,
        child: InkWell(
            onTap: () {
              _onLabelTap(id);
            },
            borderRadius: BorderRadius.circular(50),
            child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ))
                  ],
                ))));
  }
}

enum DrawerSections {
  homepage,
  history,
  ticketScan,
  settings,
  help,
}
