import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget
{
    final Function(int) idxCallback;

    const BottomBar
    ({
        required this.idxCallback,
        super.key,
    });

    @override
    State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
{
    int currentIdx = 0;

    void _onButtonTap (int idx)
    {
        setState(()
        {
            currentIdx = idx;
            widget.idxCallback(idx);
        });
    }

    @override
    Widget build (BuildContext context)
    {
        return ClipRRect
        (
            borderRadius: BorderRadius.only
            (
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
            ),

            child: NavigationBar
            (
                backgroundColor: Color(0xFFA5E6FB),

                onDestinationSelected: _onButtonTap,
                selectedIndex: currentIdx,

                destinations: const <Widget>
                [
                    NavigationDestination
                    (
                        icon: Icon(Icons.business_center),
                        label: "Current Trip",
                    ),
                    NavigationDestination
                    (
                        icon: Icon(Icons.subway),
                        label: "Stations",
                    ),
                    NavigationDestination
                    (
                        icon: Icon(Icons.train),
                        label: "Trains",
                    ),
                ],
            )
        );
    }
}
