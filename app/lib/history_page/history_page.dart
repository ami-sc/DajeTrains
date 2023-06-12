import "package:DajeTrains/api/payments_api.dart";
import "package:DajeTrains/history_page/history_top_bar.dart";
import "package:flutter/material.dart";
import 'single_payment_page.dart';


import "../structures/payment.dart";
import 'payment_list.dart';

import "../nav_drawer.dart";

class HistoryPage extends StatefulWidget {
  final NavDrawer appDrawer;

  const HistoryPage({
    required this.appDrawer,
    super.key,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  
  bool _defaultMessage = true;

  // Initialize an instance of the API.
  PaymentsApi stationsApi = PaymentsApi();
  List<Payment> paymentsList = [];

  @override
  void initState() {
    _getPaymentsHistory();
    super.initState();
  }


  void _togglePaymentPage(Payment payment) {
    // Hide the keyboard, if active.
    FocusManager.instance.primaryFocus?.unfocus();

    // Open the page.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SinglePaymentPage()),
    );
  }

  void _getPaymentsHistory() async {
    List<Payment> apiList = await PaymentsApi.getPaymentsHistory();

    if (apiList.isNotEmpty) {
      // Trigger update of the station list.
      setState(() {
        _defaultMessage = false;
        paymentsList = apiList;
      });
    } else {
      setState(() {
        _defaultMessage = true;
      });
    }
  }

  void searchPayment(String query) async {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HistoryTopBar(
        searchCallback: searchPayment,
      ),
      drawer: widget.appDrawer,
      body: _defaultMessage ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.close,
              color: Color.fromARGB(255, 174, 174, 174),
              size: 60,
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "No payments made",
                style: TextStyle(
                  color: Color.fromARGB(255, 174, 174, 174),
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ) : PaymentList(
        paymentList: paymentsList,
        paymentCallback: _togglePaymentPage,
      )
    );
  }
}

/* old build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HistoryTopBar(
        searchCallback: searchTrip,
      ),
      drawer: widget.appDrawer,
      body: Center(
          child: ElevatedButton(
        onPressed: _togglePaymentPage,
        child: Text('Show single payment page'),
      )),
    );
  }
}
*/
