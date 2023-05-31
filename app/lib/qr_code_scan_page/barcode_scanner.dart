import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'scanner_error_widget.dart';
import '../api/tickets_api.dart';
import 'validity_dialog.dart';

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
  String trainCodeExt = "";

  // API call needs to be done here
  TicketsApi api = TicketsApi();

  Future<String> _checkValidity(String? code) async {
    // Wait 500 milliseconds before sending a search request.
    // This is so we do not overload the API.
    await Future.delayed(const Duration(milliseconds: 500));

    String trainCode = await api.isValid(code);
    return trainCode;
  }

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
                    controller: MobileScannerController(
                      facing: CameraFacing.back,
                      detectionTimeoutMs: 4000,
                    ),
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, child) {
                      return ScannerErrorWidget(error: error);
                    },
                    onDetect: (capture) async {
                      print("Something was scanned: ");
                      print(capture.barcodes.first.rawValue);

                      String trainCode =
                          await _checkValidity(capture.barcodes.first.rawValue);

                      // Show a dialog with the result of the API call
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ValidityDialog(trainCode);
                        },
                      );
                      setState(() {
                        this.capture = capture;
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
