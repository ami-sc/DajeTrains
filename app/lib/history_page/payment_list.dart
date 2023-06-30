import 'package:flutter/material.dart';

import '../structures/payment.dart';
import 'single_payment_top_bar.dart';

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
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Color.fromARGB(255, 179, 179, 179),
        height: 1,
      ),
      itemCount: widget.paymentList.length,
      // Build a PaymentButton per payment on the list.
      itemBuilder: (BuildContext context, int index) {
        return PaymentButton(
          trainId: widget.paymentList[index].trainID,
          trainType:
              SingleTrainTopBar.trainType(widget.paymentList[index].trainID),
          date: widget.paymentList[index].date,
          from: widget.paymentList[index].from.name,
          to: widget.paymentList[index].to.name,
          cost: widget.paymentList[index].cost,
          listIdx: index,
          buttonCallback: _paymentButtonPress,
        );
      },
    );
  }
}

class PaymentButton extends StatelessWidget {
  final String trainId;
  final String trainType;
  final String date;
  final String from;
  final String to;
  final double cost;
  final int listIdx;
  final Function(int) buttonCallback;

  const PaymentButton({
    required this.trainId,
    required this.trainType,
    required this.date,
    required this.from,
    required this.to,
    required this.cost,
    required this.listIdx,
    required this.buttonCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Color(0xFFDAF2FF)),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            color: SingleTrainTopBar.logoColor(trainId),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        child: Center(
                          child: Text(
                            SingleTrainTopBar.trainAbbrev(trainId),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                ),
              ]),
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: Color(0xFF49454F),
                        fontSize: 14,
                      ),
                    )
                  ]),
                  Row(
                    children: [
                      Text(
                        "From: ",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF1D1B20)),
                      ),
                      Text(
                        from,
                        style: TextStyle(
                            color: Color(0xFF1D1B20),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "To: ",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF1D1B20)),
                      ),
                      Text(
                        to,
                        style: TextStyle(
                          color: Color(0xFF1D1B20),
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "$trainType - $trainId",
                        style: TextStyle(
                          color: Color(0xFF49454F),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    '€ ${cost.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
