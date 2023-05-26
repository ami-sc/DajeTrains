import 'package:flutter/material.dart';

import "top_bar.dart";
import "bottom_bar.dart";

class HomePage extends StatefulWidget
{
    @override
    State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
    int pageIdx = 0;

    void _onButtonTap (int newIdx)
    {
        setState(() {pageIdx = newIdx;});
    }

    @override
    Widget build (BuildContext context)
    {
        var bottomBar = BottomBar
        (
            idxCallback: _onButtonTap,
        );

        return Scaffold
        (
            appBar: TopBar(),

            body: <Widget>
            [
                Container
                (
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: const Text('Example Page 1'),
                ),

                Container(
                    color: Colors.green,
                    alignment: Alignment.center,
                    child: const Text('Example Page 2'),
                ),

                Container(
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const Text('Example Page 3'),
                ),
            ][pageIdx],

            bottomNavigationBar: bottomBar,
        );
    }
}
