import 'package:flutter/material.dart';

class SingleTrainTopBar extends StatefulWidget implements PreferredSizeWidget {
  const SingleTrainTopBar({
    super.key,
  });

  @override
  State<SingleTrainTopBar> createState() => _SingleTrainTopBarState();

  @override
  Size get preferredSize => Size.fromHeight(165);
}

class _SingleTrainTopBarState extends State<SingleTrainTopBar> {
  String trainType(String id) {
    switch (id.substring(0, 2)) {
      case "FR":
        return "Frecciarossa";
      case "IC":
        return "InterCity";
      default:
        return "Regionale";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFA5E6FB),
      title: Text("Ticket information"),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(182, 200, 241, 255),
            border: Border(
              bottom: BorderSide(width: 1.0, color: Color(0xFFCAC4D0)),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
            child: Row(
              children: [
                Column(// Logo
                    children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      color: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color(
                                  0xFFB71C1C), //TODO Change color based on train type
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          child: Center(
                            child: Text(
                              "FR", // TODO Change to train type
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                  ),
                ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Info
                  children: [
                    Row(
                      children: [
                        Text(
                          "Ticket for",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF49454F)),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                            "Frecciarossa - FR 9422", // TODO Change to train type
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("25 June 2021",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF49454F))),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
