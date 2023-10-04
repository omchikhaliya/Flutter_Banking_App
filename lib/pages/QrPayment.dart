import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

late final String code;

class QRPayment extends StatefulWidget {



  const QRPayment({super.key});

  @override
  State<QRPayment> createState() => _QRPaymentState();
}

class _QRPaymentState extends State<QRPayment> {



  /*late final String code;
  late final Function() closescreen;
  */

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Scan Qr Code & Pay'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //show qr here
              QrImageView(
                data : '',
                version: QrVersions.auto,
                size: 150.0,
              ),
              Text('Scanned Result',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 10,),
              Text('data',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 10,),
              Text('Scanned Completed',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
