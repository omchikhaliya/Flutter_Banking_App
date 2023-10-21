import 'package:cloud_firestore/cloud_firestore.dart';
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
  String account_holder = "";
  Customer customer_info = Customer.nothing();

  Future<void> setvariables() async {

    final pref = await SharedPreferences.getInstance();
    name1 = await pref.getString('name') ?? '';
    CustId = await pref.getString('id') ?? '';
    print('name');
    print(name1);
    print('cust id');
    print(CustId);


    CollectionReference customer = FirebaseFirestore.instance.collection('customers');
    QuerySnapshot customerQuery = await customer
        .where('customer_ID', isEqualTo: CustId)
        .get();
    final document = customerQuery.docs[0].data() as Map;
    account_holder = (document)['name'];
    customer_info = Customer.fromMap(document);
    String documentId1 = customerQuery.docs[0].id;
    print("Document ID1: $documentId1");

    // pref.setString('name', customerName);
    // pref.setString('id', customerId);
  }

  @override
  void initState() {
    super.initState();
     setvariables().then((_) {
       setState(() {}); // Trigger a rebuild after setting variables
     });
  }

  @override
  Widget build(BuildContext context)  {
    /*String customerInfo = '''
      Id ${customer.customerID}
    ''';
    */
    //initState();
    //1setvariables();
    return Scaffold(
      appBar: AppBar(
        title: Text(""+account_holder+"'s QR Code",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10.0),
            Text('Scan this QR code to Payment' ,
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 10.0),
            Text('Mr. '+ account_holder,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(7,8),
                    blurRadius: 6,
                  )
                ]
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                shadowColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: QrImageView(
                    data: CustId,
                    version: QrVersions.auto,
                    size: 250.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            /*Text('Scan this QR code to view account details'),
            SizedBox(height: 20.0),*/
            //Text("Cust id"),
            //Text(custId),
            /**/
          ],
        ),
      ),
    );
  }
}
