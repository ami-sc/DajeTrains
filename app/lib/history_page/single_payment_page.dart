import 'package:flutter/material.dart';
import 'single_payment_top_bar.dart';

class SinglePaymentPage extends StatefulWidget {
  const SinglePaymentPage({
    super.key,
  });

  @override
  State<SinglePaymentPage> createState() => _SinglePaymentPageState();
}

class _SinglePaymentPageState extends State<SinglePaymentPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SingleTrainTopBar(),
      body: Padding(
          padding: EdgeInsets.only(top: 100, left: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Info
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Departure:",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF49454F)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Station: ", style: TextStyle(fontSize: 16)),
                      Text("Napoli Afragola", // TODO Change to train name
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Date: ", style: TextStyle(fontSize: 16)),
                      Text("25/05/2023", // TODO Change to real date
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(" at ", style: TextStyle(fontSize: 16)),
                      Text("14:45", // TODO Change to real date
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 35, left: 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Arrival:",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF49454F)),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Station: ", style: TextStyle(fontSize: 16)),
                        Text("Roma Termini", // TODO Change to train name
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Date: ", style: TextStyle(fontSize: 16)),
                        Text("25/05/2023", // TODO Change to real date
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(" at ", style: TextStyle(fontSize: 16)),
                        Text("16:05", // TODO Change to real date
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(children: [
                      Text("Scheduled at 15:22",
                          style: TextStyle(fontSize: 16)),
                    ])
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
