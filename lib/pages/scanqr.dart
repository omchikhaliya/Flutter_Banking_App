import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
//import 'package:mobile_scanner/mobile_scanner_web.dart';

import 'QRScannerOverlay.dart';
import 'QrPayment.dart';

const bgColor = Color(0xfffafafa);

class Scanqr extends StatefulWidget {
  const Scanqr({super.key});

  @override
  State<Scanqr> createState() => _ScanqrState();
}

class _ScanqrState extends State<Scanqr> {

  bool isScanCompleted = false;

  void closeScreen()
  {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Scan Qr Code & Pay'),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Place the Qr code in the area.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text('Scan will be start automaticatlly',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 4,
                /*child: Container(
                   color : Colors.green,
                  ),*/

              child: Stack(
                children: [
                  MobileScanner(
                    //allowDuplicates = true;
                    onDetect: (capture) {
                      if(!isScanCompleted) {
                        final List<Barcode> barcodes = capture.barcodes;
                        final Uint8List? image = capture.image;
                        for (final barcode in barcodes) {
                          debugPrint('Barcode found! ${barcode.rawValue}');
                        }
                        print("barcodes");
                        print(barcodes.toString());
                        print(image);
                        String? qrCodeData =" ";
                        /*
                        String code = capture.raw ?? '---'; //rawValue ?? '---';*/
                        if (barcodes.isNotEmpty) {
                          // Assuming you want to use the first detected barcode
                           qrCodeData = barcodes.first.rawValue;

                          // Navigate to the QRPayment page and pass the scanned QR code data
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  //QRPayment(qrData: qrCodeData),
                              QRPayment(),
                            ),
                          );*/
                           isScanCompleted = false;
                          Navigator.pushNamed(context, '/qr_payment',arguments: {
                            'qrCodeData' : qrCodeData
                          });
                          isScanCompleted = true;
                          //Navigator.push(context,MaterialPageRoute(builder: (context) => QRPayment()));/**/ // '/qr_payment',{code: code});
                        }
                      }
                    },
                  ),
                  QRScannerOverlay(overlayColour : Colors.white),
                ]
              ),
            ),
            Expanded(
                child: Container(
                  alignment: Alignment.center,

                )),
          ],
        ),
      ),
    );
  }
}
