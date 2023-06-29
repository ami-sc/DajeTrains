import 'package:flutter/material.dart';
import 'drawer_header.dart';

class NavDrawer extends StatefulWidget {
  final Function(int) indexCallback;
  final int targetIdx;

  const NavDrawer({
    required this.indexCallback,
    required this.targetIdx,
    super.key,
  });

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  int currentIdx = 0;

  void _onLabelTap(int idx) {
    setState(() {
      currentIdx = idx;
      widget.indexCallback(idx);
      Navigator.pop(context);
    });
  }

  bool _isSelected(int value) {
    if (currentIdx == value) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFCEF3FF),
      child: SingleChildScrollView(
          child: Container(
        child: Column(children: [
          MyHeaderDrawer(),
          drawerList(),
        ]),
      )),
    );
  }

  Widget drawerList() {
    currentIdx = widget.targetIdx;
    return Container(
      padding: EdgeInsets.only(top: 15.0, right: 30, left: 30),
      child: Column(children: [
        // Show the list of menu drawer
        menuItem(0, "Homepage", _isSelected(0)),
        menuItem(3, "History", _isSelected(1)),
        menuItem(4, "Scan ticket/pass", _isSelected(2)),
        menuItem(5, "Settings", _isSelected(3)),
        menuItem(6, "Need help?", _isSelected(4)),
      ]),
    );
  }

  IconData _getIcon(String title) {
    switch (title) {
      case "Homepage":
        return Icons.home;
      case "History":
        return Icons.history;
      case "Scan ticket/pass":
        return Icons.qr_code_scanner;
      case "Settings":
        return Icons.settings;
      case "Need help?":
        return Icons.help_outline_sharp;
      default:
        return Icons.home;
    }
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
                      flex: 2,
                      child: Icon(_getIcon(title))
                    ),
                    Expanded(
                      flex: 8,
                      child: Text(
                        title,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      )
                    )
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
