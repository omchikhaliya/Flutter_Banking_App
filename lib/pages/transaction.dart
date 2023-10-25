import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:banking_application/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Widget _buildTextField(TextEditingController controller, String label,
//     {bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     FocusNode? focusNode,
//     String? errorText}) {
//   return TextFormField(
//     controller: controller,
//     decoration: InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(
//         borderSide:  BorderSide(color: Colors.black),
//         borderRadius: BorderRadius.circular(20.0),
//       ),
//       errorText: errorText,
//     ),
//     obscureText: obscureText,
//     keyboardType: keyboardType,
//     focusNode: focusNode,
//   );
// }

Widget _buildTextField(
    TextEditingController controller,
    String label,
    {
      bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      FocusNode? focusNode,
      String? errorText,
      bool enabled = true, // Add this parameter for enabling/disabling the field
    }) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(20.0),
      ),
      errorText: errorText,
    ),
    obscureText: obscureText,
    keyboardType: keyboardType,
    focusNode: focusNode,
    enabled: enabled, // Set the enabled property
  );
}

Account account_info = Account.nothing();
String sender_account_no = "";

Future<void> initializevalues()async {
  final pref = await SharedPreferences.getInstance();
  final CustId = pref.getString('id') ?? '';
  CollectionReference account = FirebaseFirestore.instance.collection('accounts');
  QuerySnapshot accountQuery = await account
      .where('customer_ID', isEqualTo: CustId)
      .get();
  final document1 = accountQuery.docs[0].data() as Map;
  account_info = Account.fromMap(document1);
  sender_account_no = account_info.account_no!;
  print(sender_account_no);
}

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {

  TextEditingController senderAccountController = TextEditingController();
  TextEditingController receiverAccountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController transactionPinController = TextEditingController();

  FocusNode senderAccountFocus = FocusNode();
  FocusNode receiverAccountFocus = FocusNode();
  FocusNode amountFocus = FocusNode();

  String? senderValidationMessage;
  String? receiverValidationMessage;
  String? amountValidationMessage;
  String? pinValidationMessage;


  @override
  void initState() {
    super.initState();

    initializevalues().then((_) {
      ;
      setState(() {
        senderValidationMessage;

        // Attach listeners to the fields to trigger validations when leaving the field
        // senderAccountFocus.addListener(() {
        //   validateSenderAccount(
        //       senderAccountController.text, receiverAccountController.text);
        // });

        receiverAccountFocus.addListener(() {
          validateReceiverAccount(
              receiverAccountController.text, senderAccountController.text);
        });

        amountFocus.addListener(() {
          validateAmount(amountController.text, senderAccountController.text);
        });

        initializevalues();
        senderAccountController.text = sender_account_no;
      });
    });
  }

  Future<void> validateSenderAccount(
      String accountNumber, String receiverNumber) async {
    try {
      // Replace this with your sender account validation logic
      // For example, query your Firestore collection for sender accounts
      // Reference to the Firestore collection where sender accounts are stored

      if (accountNumber == receiverNumber &&
          (accountNumber != '' || receiverNumber != '')) {
        setState(() {
          senderValidationMessage = "Sender & Receiver can't be Same.";
        });
        return;
      }

      CollectionReference senderAccounts =
          FirebaseFirestore.instance.collection('accounts');
      // Query the Firestore collection for a specific document based on sender account number
      QuerySnapshot accountQuery = await senderAccounts
          .where('account_no', isEqualTo: accountNumber)
          .get();
      if (accountQuery.docs.isNotEmpty) {
        // Sender account number found
        setState(() {
          senderValidationMessage = null;
        });
      } else {
        // Sender account number not found
        setState(() {
          senderValidationMessage = "Sender account is invalid.";
        });
      }
    } catch (e) {
      // Handle any errors that occur during the process
      setState(() {
        senderValidationMessage = "Error validating sender account.";
      });
    }
  }

  Future<void> validateReceiverAccount(
      String accountNumber, String senderNumber) async {
    try {
      // Replace this with your receiver account validation logic
      // For example, query your Firestore collection for receiver accounts
      // Reference to the Firestore collection where receiver accounts are stored
      if (accountNumber == senderNumber &&
          (accountNumber != '' || senderNumber != '')) {
        setState(() {
          receiverValidationMessage = "Sender & Receiver can't be Same.";
        });
        return;
      }

      CollectionReference receiverAccounts =
          FirebaseFirestore.instance.collection('accounts');

      // Query the Firestore collection for a specific document based on receiver account number
      QuerySnapshot accountQuery = await receiverAccounts
          .where('account_no', isEqualTo: accountNumber)
          .get();

      if (accountQuery.docs.isNotEmpty) {
        // Receiver account number found
        setState(() {
          receiverValidationMessage = null;
        });
      } else {
        // Receiver account number not found
        setState(() {
          receiverValidationMessage = "Receiver account is invalid.";
        });
      }
    } catch (e) {
      // Handle any errors that occur during the process
      setState(() {
        receiverValidationMessage = "Error validating receiver account.";
      });
    }
  }

  Future<void> validateAmount(String amount, String accountNumber) async {
    // You can implement validation logic for the amount field here
    // For example, check if it's a valid numeric value
    try {
      CollectionReference account =
          FirebaseFirestore.instance.collection('accounts');
      int parsedAmount = int.parse(amount);
      QuerySnapshot accountQuery =
          await account.where('account_no', isEqualTo: accountNumber).get();
      if (parsedAmount <= 0) {
        setState(() {
          amountValidationMessage = "Amount must be non-negative.";
        });
      } else if (accountQuery.docs.isNotEmpty) {
        final document = accountQuery.docs[0].data();
        final balance = (document as Map)['balance'];
        if (balance >= parsedAmount) {
          setState(() {
            amountValidationMessage = null;
          });
        } else {
          setState(() {
            amountValidationMessage = "Invalid amount.";
          });
        }
      }
    } catch (e) {
      setState(() {
        amountValidationMessage = "Invalid amount.";
      });
    }
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
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Transaction Successful'),
                content: Text('Amount Transferred Successfully'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, '/profile');
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      }
      else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Transaction Failed'),
                content: Text('Incorrect PIN entered'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, '/profile');
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Page'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildTextField(
                      senderAccountController,
                      "Sender's Account No",
                      keyboardType: TextInputType.number,
                      focusNode: senderAccountFocus,
                      errorText: senderValidationMessage,
                      enabled: false, // Set the field as disabled
                    ),
                    SizedBox(height: 16.0),
                    _buildTextField(
                      receiverAccountController,
                      "Receiver's Account No",
                      keyboardType: TextInputType.number,
                      focusNode: receiverAccountFocus,
                      errorText: receiverValidationMessage,
                    ),
                    SizedBox(height: 16.0),
                    _buildTextField(
                      amountController,
                      "Amount",
                      keyboardType: TextInputType.number,
                      focusNode: amountFocus,
                      errorText: amountValidationMessage,
                    ),
                    SizedBox(height: 16.0),
                    _buildTextField(remarkController, "Remark"),
                    SizedBox(height: 16.0),
                    _buildTextField(transactionPinController, "Transaction PIN",
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        errorText: pinValidationMessage),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        // Handle the transaction here
                        String senderAccount = senderAccountController.text;
                        String receiverAccount = receiverAccountController.text;
                        String amount = amountController.text;
                        String remark = remarkController.text;
                        String transactionPin = transactionPinController.text;

                        // Add your transaction logic here
                        await handlesubmit(senderAccount, receiverAccount,
                            amount, remark, transactionPin);

                        // Print the input values for testing
                        print("Sender's Account: $senderAccount");
                        print("Receiver's Account: $receiverAccount");
                        print("Amount: $amount");
                        print("Remark: $remark");
                        print("Transaction PIN: $transactionPin");
                      },
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            'Send',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),


                          backgroundColor: Colors.black,

                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
