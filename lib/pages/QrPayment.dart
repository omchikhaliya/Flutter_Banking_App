import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:banking_application/models/cutomers.dart';
import 'package:banking_application/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:banking_application/pages/scanqr.dart';

late final String code;

class QRPayment extends StatefulWidget {


  //final String? qrData;
  //const QRPayment({required this.qrData, Key? key}) : super(key: key);
  QRPayment({super.key});
  @override
  State<QRPayment> createState() => _QRPaymentState();
}

class _QRPaymentState extends State<QRPayment> {

  /*late final String code;
  late final Function() closescreen;
  */
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _remark = TextEditingController();

  Map<dynamic,dynamic> Data = {};
  String name1="";
  String CustId = "";
  String account_holder = "";
  String account_no = "";
  String card_no = "";
  String Amount = "";
  Customer customer_info = Customer.nothing();
  Customer current_customer_info = Customer.nothing();
  Account account_info = Account.nothing();
  Account current_account_info = Account.nothing();
  String QrData = "";
  String Remark = "";
  bool isAmountValid = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Move the logic that depends on inherited widgets here
    setvariables().then((_) {
      setState(() {}); // Trigger a rebuild after setting variables
    });
  }

  Future<void> setvariables() async {
    //super.initState();
    //super.initState();

    //Data = Data.isEmpty ? {'qrCodeData':"111111"} :  ModalRoute.of(context)?.settings.arguments as Map; //: {'qrCodeData':"111111"};
    Data =  ModalRoute.of(context)?.settings.arguments as Map; //{'qrCodeData':"111111"};
    print(Data);
    QrData = Data['qrCodeData'];

    final pref = await SharedPreferences.getInstance();
    name1 = pref.getString('name') ?? '';
    CustId = pref.getString('id') ?? '';
    // pref.setString('name', customerName);
    // pref.setString('id', customerId);

    //CustId = '111112';


    CollectionReference customer = FirebaseFirestore.instance.collection('customers');
    QuerySnapshot customerQuery = await customer
        .where('customer_ID', isEqualTo: QrData)
        .get();
    final document = customerQuery.docs[0].data() as Map;
    account_holder = (document)['name'];
    print(account_holder);

    CollectionReference account = FirebaseFirestore.instance.collection('accounts');
    QuerySnapshot accountQuery = await account
        .where('customer_ID', isEqualTo: QrData)
        .get();
    customer_info = Customer.fromMap(document);
    
    print(document);
    final document1 = accountQuery.docs[0].data() as Map;
    account_info = Account.fromMap(document1);
    print(document1);

    print("1");
    CollectionReference current_customer = FirebaseFirestore.instance.collection('customers');
    QuerySnapshot current_customerQuery = await current_customer
        .where('customer_ID', isEqualTo: CustId)
        .get();

    final document2 = current_customerQuery.docs[0].data() as Map;
    current_customer_info = Customer.fromMap(document2);

    print(document2);

    print("2");
    CollectionReference current_account = FirebaseFirestore.instance.collection('accounts');
    QuerySnapshot current_accountQuery = await current_account
        .where('customer_ID', isEqualTo: CustId)
        .get();

    print(current_accountQuery.docs);
    print("heell");
    final document3 = current_accountQuery.docs[0].data() as Map;
    current_account_info = Account.fromMap(document3);

    print(document3);
    print("3");
  }

  void VerifyAmount() async
  {
    print("hu");
    int am = int.parse(_amount.text) ;
    print(am);
    print("balance : ");
    print(current_account_info.balance);
    int? curr_am = current_account_info.balance;
    print("amount");
    print(_amount.text);

    print("balance : ");
    print(current_account_info.balance);

    if( am >= curr_am! )
      {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
          content: Text("Input valid amount."),
        ));
      }
    else{
      isAmountValid = true;
    }
  }

  @override
  void initState() {
    super.initState();
    super.initState();
    /*setvariables().then((_) {
      setState(() {}); // Trigger a rebuild after setting variables
    });*/
  }

  //String data = qrData;
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: Text('Scan Qr Code & Pay'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //show qr here
                SizedBox(height: 120,),
                Text('Bharat National Bank',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 75,),
                Text('Pay to Mr.' + account_holder,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Remark : ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 8,),
                    Container(
                      width: 200, // Adjust the width as needed
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        controller: _remark,
                      ),
                    ),
                  ],
                ),
                /*Container(
                  width: 150, // Adjust the width as needed
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    controller: _remark,
                    keyboardType: TextInputType.number,
                  ),
                ),*/
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Amount',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(': ₹ ',
                      style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 8,),
                    Container(
                      width: 150, // Adjust the width as needed
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        controller: _amount,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50,),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () async{
                      print(_amount.text);

                      VerifyAmount();

                      if(isAmountValid)
                        {
                          Navigator.pushNamed(
                              context, '/qr_pay',arguments: {'amount' : _amount.text,'remark' : _remark.text,'reciver_Cust' : QrData });
                        }
                    },
                    child: const Text(
                      'Enter Pin',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                /*QrImageView(
                  data : QrData,
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
                Text(QrData,
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
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
