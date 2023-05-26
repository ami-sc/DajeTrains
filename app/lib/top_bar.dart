import 'package:flutter/material.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget
{
    @override
    State<TopBar> createState() => _TopBarState();

    @override
    Size get preferredSize => Size.fromHeight(60);
}

class _TopBarState extends State<TopBar>
{
    @override
    Widget build (BuildContext context)
    {
        return AppBar
        (
            backgroundColor: Color(0xFFA5E6FB),

            title: Text("DajeTrains"),
            centerTitle: true,

            leading: Icon(Icons.menu),

            actions:
            [
                Padding
                (
                    padding: const EdgeInsets.all(15),
                    child: Icon(Icons.account_circle_rounded),
                ),
            ]
        );
    }
}
