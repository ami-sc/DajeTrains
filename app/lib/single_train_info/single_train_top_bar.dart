import 'package:flutter/material.dart';

class SingleTrainTopBar extends StatefulWidget implements PreferredSizeWidget {
  const SingleTrainTopBar({
    super.key,
  });

  @override
  State<SingleTrainTopBar> createState() => _SingleTrainTopBarState();

  @override
  Size get preferredSize => Size.fromHeight(190);
}

class _SingleTrainTopBarState extends State<SingleTrainTopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFA5E6FB),
      title: Text("Train information"),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: Container(
            color: Color(0xFFC8F1FF),
            child: Text(
              "test aivbudbvuesblubevl.uvlaeswblkeubveuekbewiuewuvbhewklvubeuvbewuò",
              style: TextStyle(fontSize: 30),
            )),
      ),
    );
  }
}
