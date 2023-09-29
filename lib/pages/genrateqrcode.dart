import 'package:flutter/material.dart';

import '../models/account.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:banking_application/models/cutomers.dart';

class GenerateQRCode extends StatelessWidget {
  //final Account account;

  //final Customer customer;
  //GenerateQRCode(this.customer);

  @override
  Widget build(BuildContext context) {
    /*String customerInfo = '''
      Id ${customer.customerID}
    ''';
    */
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImageView(
              data: "111112",
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20.0),
            Text('Scan this QR code to view account details'),
          ],
        ),
      ),
    );
  }
}
