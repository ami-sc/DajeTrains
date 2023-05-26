import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "home_page.dart";
import "side_menu.dart";

void main()
{
    runApp(DajeTrains());
}

class DajeTrains extends StatelessWidget
{
    const DajeTrains({super.key});

    @override
    Widget build(BuildContext context)
    {
        return ChangeNotifierProvider
        (
            create: (context) => AppState(),
            child: MaterialApp
            (
                title: "DajeTrains",
                theme: ThemeData
                (
                    useMaterial3: true,
                ),

                home: HomePage(),
            ),
        );
    }
}

class AppState extends ChangeNotifier {}
