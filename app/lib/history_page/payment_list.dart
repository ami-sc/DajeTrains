import 'package:flutter/material.dart';

import '../structures/payment.dart';

class PaymentList extends StatefulWidget {
  final List<Payment> paymentList;
  final Function(Payment) paymentCallback;

  const PaymentList({
    required this.paymentList,
    required this.paymentCallback,
    super.key,
  });

  @override
  State<PaymentList> createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  void _paymentButtonPress(int paymentIdx) {
    widget.paymentCallback(widget.paymentList[paymentIdx]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.paymentList.length,
      // Build a PaymentButton per payment on the list.
      itemBuilder: (BuildContext context, int index) {
        return PaymentButton(
          paymentName: widget.paymentList[index].arrivalTime,
          listIdx: index,
          buttonCallback: _paymentButtonPress,
        );
      },
    );
  }
}

class PaymentButton extends StatelessWidget {
  final String paymentName;
  final int listIdx;
  final Function(int) buttonCallback;

  const PaymentButton({
    required this.paymentName,
    required this.listIdx,
    required this.buttonCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextButton.icon(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.fromLTRB(30, 10, 0, 0),
          ),
          alignment: Alignment.centerLeft,
          overlayColor: MaterialStateProperty.all(Color(0xFFB5D7FF)),
          // Make the highlight shape a square.
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        onPressed: () {
          print("PaymentList::Payment::onPressed");
          // Return the index (according to the PaymentList) of the Payment.
          buttonCallback(listIdx);
        },
        icon: Icon(
          Icons.subway_outlined,
          color: Color.fromARGB(255, 55, 62, 71),
          size: 28,
        ),
        label: Text(
          paymentName,
          style: TextStyle(
            color: Color.fromARGB(255, 55, 62, 71),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
