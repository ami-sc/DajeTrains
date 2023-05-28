import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "page_manager.dart";

void main() {
  runApp(DajeTrains());
}

class DajeTrains extends StatefulWidget {
  const DajeTrains({super.key});

  @override
  State<DajeTrains> createState() => _DajeTrainsState();
}

class _DajeTrainsState extends State<DajeTrains> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: "DajeTrains",
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: Home(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {}
