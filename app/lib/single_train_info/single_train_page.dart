import 'package:flutter/material.dart';
import "single_train_top_bar.dart";

class SingleTrainPage extends StatefulWidget {
  final String trainID;

  const SingleTrainPage({
    required this.trainID,
    super.key,
  });

  @override
  State<SingleTrainPage> createState() => _SingleTrainPageState();
}

class _SingleTrainPageState extends State<SingleTrainPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    print("Train info page init");
    print(widget.trainID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SingleTrainTopBar(),
      body: Container(
        child: Text(widget.trainID),
      ),
    );
  }
}
