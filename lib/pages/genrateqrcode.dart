import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:banking_application/models/cutomers.dart';


class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});

  @override
  State<GenerateQRCode> createState() => _GenerateQRCodeState();
}

class _GenerateQRCodeState extends State<GenerateQRCode> {

  //final Account account;

  //final Customer customer;
  //GenerateQRCode(this.customer);

  String name1="";
  String CustId = "";
  String custId = '';
  void setvariables() async {
    super.initState();
    final pref = await SharedPreferences.getInstance();
    name1 = await pref.getString('name') ?? '';
    CustId = await pref.getString('id') ?? '';
    print('name');
    print(name1);
    custId = CustId;
    print('cust id');
    print(CustId);
    print(custId);
    // pref.setString('name', customerName);
    // pref.setString('id', customerId);
  }

  @override
  void initState() {
     setvariables();
  }

  @override
  Widget build(BuildContext context)  {
    /*String customerInfo = '''
      Id ${customer.customerID}
    ''';
    */
    //initState();
    //setvariables();
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImageView(
              data: custId,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20.0),
            Text('Scan this QR code to view account details'),
            SizedBox(height: 20.0),
            Text("Cust id"),
            Text(custId),
            /**/
          ],
        ),
      ),
    );
  }
}
