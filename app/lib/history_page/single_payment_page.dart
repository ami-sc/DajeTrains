import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'single_payment_top_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../structures/payment.dart';

class SinglePaymentPage extends StatefulWidget {
  final Payment payment;

  const SinglePaymentPage({
    required this.payment,
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
    var scheduleDepartureTime = widget.payment.scheduleDepartureTime;
    var scheduleArrivalTime = widget.payment.scheduleArrivalTime;
    var cost = widget.payment.cost;
    // Calculate delay

    var dif = "0";

    // Parse the string to a DateTime object
    if (widget.payment.arrivalTime != "") {
      DateTime startDate =
          DateFormat("hh:mm").parse(widget.payment.arrivalTime);
      DateTime endDate = DateFormat("hh:mm").parse(scheduleArrivalTime);

      // Get the Duration using the diferrence method
      Duration diff = startDate.difference(endDate);
      dif = diff.inMinutes.toString();
    }

    print(dif);

    return Scaffold(
      appBar: SingleTrainTopBar(payment: widget.payment),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          // Info
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Departure:",
                      style: TextStyle(fontSize: 12, color: Color(0xFF49454F)),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Station: ", style: TextStyle(fontSize: 16)),
                    Text(widget.payment.from.name, // TODO Change to train name
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Text("Date: ", style: TextStyle(fontSize: 16)),
                    Text(widget.payment.date, // TODO Change to real date
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(" at ", style: TextStyle(fontSize: 16)),
                    Text(
                        widget
                            .payment.departureTime, // TODO Change to real date
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(children: [
                  Text("Scheduled at $scheduleDepartureTime",
                      style: TextStyle(fontSize: 16)),
                ])
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
                      Text(widget.payment.to.name, // TODO Change to train name
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Date: ", style: TextStyle(fontSize: 16)),
                      Text(widget.payment.date, // TODO Change to real date
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(" at ", style: TextStyle(fontSize: 16)),
                      Text(
                          widget
                              .payment.arrivalTime, // TODO Change to real date
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(children: [
                    Text("Scheduled at $scheduleArrivalTime",
                        style: TextStyle(fontSize: 16)),
                  ])
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 35, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      int.parse(dif) > 0
                          ? Text(
                              "Delay: $dif minutes",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFB71C1C),
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            )
                          : Text(
                              "On time",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 53, 187, 51),
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            )
                    ],
                  ),
                  if (int.parse(dif) > 10)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: _launchURL,
                          child: Text("Request refund",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3366BB),
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF3366BB),
                              )),
                        )
                      ],
                    ),
                ],
              ),
            ),

            Divider(
              color: Color(0xFF49454F),
              thickness: 1,
              indent: 0,
            ),

            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Total:",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF49454F)),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          "€ ${cost.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(flex: 2, child: SizedBox.shrink()),

                  Expanded(
                    flex: 4,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.flag, color: Colors.white),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFB71C1C)),
                      ),
                      label: Text("Report",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ),
                  
                  SizedBox(width: 15,),
                  
                  Expanded(
                    flex: 4,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFA5E6FB)),
                      ),
                      onPressed: () {},
                      icon: Icon(Icons.receipt_long, color: Color(0xFFA5E6FB)),
                      label: Text("Receipt",
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                    )
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  _launchURL() async {
    final Uri url = Uri.parse('https://trenitalia.com');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
