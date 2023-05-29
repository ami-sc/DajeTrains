import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'scanner_error_widget.dart';
import '../api/tickets_api.dart';

class BarcodeScannerWithoutController extends StatefulWidget {
  const BarcodeScannerWithoutController({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWithoutControllerState createState() =>
      _BarcodeScannerWithoutControllerState();
}

class _BarcodeScannerWithoutControllerState
    extends State<BarcodeScannerWithoutController>
    with SingleTickerProviderStateMixin {
  BarcodeCapture? capture;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        height: 450,
        width: 300,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Builder(
            builder: (context) {
              return Stack(
                children: [
                  MobileScanner(
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, child) {
                      return ScannerErrorWidget(error: error);
                    },
                    onDetect: (capture) {
                      setState(() {
                        this.capture = capture;
                        print("Something was scanned: ");
                        print(capture.barcodes.first.rawValue);
                        // API call needs to be done here
                        TicketsApi api = TicketsApi();
                        print(api.isValid(capture.barcodes.first.rawValue));
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
