import 'package:flutter/material.dart';
import 'single_payment_top_bar.dart';
import 'package:url_launcher/url_launcher.dart';

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
          // Info
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
                    Text("Scheduled at 15:22", style: TextStyle(fontSize: 16)),
                  ])
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 35, right: 30, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Delay: 43 minutes",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFB71C1C),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
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
              endIndent: 30,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, right: 30),
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
                      Text("€ 18.00", // TODO Change to real cost
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 100, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child:
                        // Add two buttons
                        ElevatedButton.icon(
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
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFA5E6FB)),
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.receipt_long, color: Color(0xFFA5E6FB)),
                    label: Text("Receipt",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
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
