import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:banking_application/models/cutomers.dart';
import 'package:banking_application/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrPay extends StatefulWidget {
  const QrPay({super.key});

  @override
  State<QrPay> createState() => _QrPayState();
}

class _QrPayState extends State<QrPay> {

  final TextEditingController _pin = TextEditingController();

  Map<dynamic,dynamic> Data = {};

  String amount = "";
  String reciver_Cust = "";
  String Remark = "";
  String name1="";
  String CustId = "";
  String account_holder = "";
  String account_no = "";
  String card_no = "";
  //String Amount = "";
  Customer customer_info = Customer.nothing();
  Customer current_customer_info = Customer.nothing();
  Account account_info = Account.nothing();
  Account current_account_info = Account.nothing();
  String QrData = "";
  bool isAmountValid = false;
  String? pinValidationMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Move the logic that depends on inherited widgets here
    setVariables().then((_) {
      setState(() {}); // Trigger a rebuild after setting variables
    });
  }

  Future<void> setVariables() async
  {
    //setVariables();
    //super.initState();
    Data = ModalRoute.of(context)?.settings.arguments as Map;
    print(Data);
    print(Data.isEmpty);
    //Data = Data.isEmpty ? {'reciver_Cust':"111111" , 'amount' : "0"} :  ModalRoute.of(context)?.settings.arguments as Map; //: {'qrCodeData':"111111"};

    amount = Data['amount'];
    reciver_Cust = Data['reciver_Cust'];
    Remark = Data['remark'];

    final pref = await SharedPreferences.getInstance();
    name1 = pref.getString('name') ?? '';
    CustId = pref.getString('id') ?? '';
    // pref.setString('name', customerName);
    // pref.setString('id', customerId);

    //CustId = '111112';
    CollectionReference customer = FirebaseFirestore.instance.collection('customers');
    QuerySnapshot customerQuery = await customer
        .where('customer_ID', isEqualTo: reciver_Cust)
        .get();
    final document = customerQuery.docs[0].data() as Map;
    account_holder = (document)['name'];
    print(account_holder);

    CollectionReference account = FirebaseFirestore.instance.collection('accounts');
    QuerySnapshot accountQuery = await account
        .where('customer_ID', isEqualTo: reciver_Cust)
        .get();
    customer_info = Customer.fromMap(document);

    print(document);
    final document1 = accountQuery.docs[0].data() as Map;
    account_info = Account.fromMap(document1);
    print(document1);

    //print("1");
    CollectionReference current_customer = FirebaseFirestore.instance.collection('customers');
    QuerySnapshot current_customerQuery = await current_customer
        .where('customer_ID', isEqualTo: CustId)
        .get();

    final document2 = current_customerQuery.docs[0].data() as Map;
    current_customer_info = Customer.fromMap(document2);

    print(document2);

    //print("2");
    CollectionReference current_account = FirebaseFirestore.instance.collection('accounts');
    QuerySnapshot current_accountQuery = await current_account
        .where('customer_ID', isEqualTo: CustId)
        .get();

    print(current_accountQuery.docs);
    print("heell");
    final document3 = current_accountQuery.docs[0].data() as Map;
    current_account_info = Account.fromMap(document3);

    print(document3);
   // print("3");


    //setState(() {});
  }

  Future<void> handlesubmit(String senderAccount, String receiverAccount,
      String amount, String remark, String transactionPin) async {
    final parsedAmount = int.parse(amount);
    final parsedpin = int.parse(transactionPin);
    DateTime now = new DateTime.now();
    CollectionReference account =
    FirebaseFirestore.instance.collection('accounts');

    QuerySnapshot sender_account =
    await account.where('account_no', isEqualTo: senderAccount).get();
    if (sender_account.docs.isNotEmpty) {
      final document = sender_account.docs[0].data();
      final pin = (document as Map)['transaction_pin'];
      if (pin == parsedpin) {
        CollectionReference transaction =
        FirebaseFirestore.instance.collection('transaction');
        await transaction.add({
          'sender_account_no': senderAccount,
          'receiver_account_no': receiverAccount,
          'amount': parsedAmount,
          'remarks': remark,
          'date': now
        }).then((value) => print("Added Data"));
        final DocumentReference sender_doc = sender_account.docs[0].reference;
        final bal = (document as Map)['balance'];
        final rem_bal = bal - parsedAmount;

        await sender_doc.update({'balance': rem_bal});
        QuerySnapshot receiver =
        await account.where('account_no', isEqualTo: receiverAccount).get();
        final DocumentReference receiver_doc = receiver.docs[0].reference;
        final receiver_doc_data = receiver.docs[0].data();
        final receiver_bal = (receiver_doc_data as Map)['balance'];
        final new_bal = receiver_bal + parsedAmount;
        await receiver_doc.update({'balance': new_bal});

        ScaffoldMessenger.of(context)
            .showSnackBar( SnackBar(
          content: Text('Payment Successful.'),
        ));
        Navigator.pushReplacementNamed(
            context, '/home');

      }
    } else {
      setState(() {
        pinValidationMessage = "PIN is Incorrect";
        ScaffoldMessenger.of(context)
            .showSnackBar( SnackBar(
          content: Text(pinValidationMessage!),

        ));
      });
    }
  }

  /*@override
  void initState() {

    super.initState();
    /*setVariables().then((_) {
      setState(() {}); // Trigger a rebuild after setting variables
    });*/
    /*Data = ModalRoute.of(context)?.settings.arguments as Map;
    print(Data.isEmpty);
    Data = Data.isEmpty ? {'reciver_Cust':"111111" , 'amount' : "0"} :  ModalRoute.of(context)?.settings.arguments as Map; //: {'qrCodeData':"111111"};

    amount = Data['amount'];
    reciver_Cust = Data['reciver_Cust'];*/
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Pay'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                Text('Amount : ₹ ' + amount + ' /-',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 20,),
                Text('Enter 4 - digit pin',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Container(
                      width: 150, // Adjust the width as needed
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        controller: _pin,
                        keyboardType: TextInputType.number,
                      ),
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
                      String senderAccount = current_account_info.account_no.toString();
                      String receiverAccount = account_info.account_no.toString();
                      /*String amount = amount;
                      String remark = Remark;*/
                      String transactionPin = _pin.text;

                      // Add your transaction logic here
                      await handlesubmit(senderAccount, receiverAccount,
                          amount, Remark, transactionPin);

                      // Print the input values for testing
                      print("Sender's Account: $senderAccount");
                      print("Receiver's Account: $receiverAccount");
                      print("Amount: $amount");
                      print("Remark: $Remark");
                      print("Transaction PIN: $transactionPin");

                      /*print(_amount.text);

                      VerifyAmount();

                      if(isAmountValid)
                      {
                        Navigator.pushNamed(
                            context, '/qr_pay',arguments: {'amount' : _amount.text,'reciver_Cust' : QrData });
                      }*/
                    },
                    child: const Text(
                      'Pay',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                /*Text('Amount ' + amount,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 10,),
                Text('Pay to Mr.' + reciver_Cust,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 10,),*/
              ],
            ),
          ),
        ),
      )
    );
  }
}
