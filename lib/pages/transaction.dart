// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class TransactionPage extends StatefulWidget {
//   @override
//   _TransactionPageState createState() => _TransactionPageState();
// }
//
// class _TransactionPageState extends State<TransactionPage> {
//   final TextEditingController senderAccountController = TextEditingController();
//   final TextEditingController receiverAccountController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController remarkController = TextEditingController();
//   final TextEditingController transactionPinController = TextEditingController();
//
//   final FocusNode senderAccountFocus = FocusNode(); // Create a FocusNode for sender's account
//
//   bool isSenderAccountValid = false; // Track if the sender's account is valid
//
//   @override
//   void dispose() {
//     senderAccountFocus.dispose(); // Dispose of the FocusNode when done
//     super.dispose();
//   }
//
//   // Simulated function to validate the sender's account number
//   Future<bool> validateSenderAccount(String accountNumber) async {
//     final CollectionReference account = FirebaseFirestore.instance.collection("accounts");
//     // await Future.delayed(Duration(seconds: 2)); // Simulate a delay
//     try{
//       final QuerySnapshot<Object?> querySnapshot = await account.where('account_no', isEqualTo: accountNumber ).get();
//       print("||||||||||||||||||||||||||||||||||");
//       print(querySnapshot.docs[0]);
//       print("||||||||||||||||||||||||||||||||||");
//       if(querySnapshot.docs.isNotEmpty){
//         return true;
//       }
//       else{
//         return false;
//       }
//     }
//     catch(e){
//       print(e);
//     }
//     return false;
//     // Example: Check if the account number is valid
//     // return accountNumber == '1234567890'; // Replace with your validation logic
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Attach a listener to the sender's account number field
//     senderAccountFocus.addListener(() async {
//       if (!senderAccountFocus.hasFocus) {
//         // When the user leaves the sender's account field, trigger validation
//         final accountNumber = senderAccountController.text;
//         final isValid = await validateSenderAccount(accountNumber);
//
//         setState(() {
//           isSenderAccountValid = isValid;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Transaction Page'),
//       ),
//       resizeToAvoidBottomInset: true,
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 4.0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 _buildTextField(
//                   senderAccountController,
//                   "Sender's Account No",
//                   focusNode: senderAccountFocus, // Attach the FocusNode
//                   errorText: isSenderAccountValid ? null : 'Invalid Account No', // Show error message if not valid
//                 ),
//                 SizedBox(height: 16.0),
//                 _buildTextField(receiverAccountController, "Receiver's Account No"),
//                 SizedBox(height: 16.0),
//                 _buildTextField(amountController, "Amount", keyboardType: TextInputType.number),
//                 SizedBox(height: 16.0),
//                 _buildTextField(remarkController, "Remark"),
//                 SizedBox(height: 16.0),
//                 _buildTextField(transactionPinController, "Transaction PIN", obscureText: true),
//                 SizedBox(height: 20.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle the transaction here
//                     String senderAccount = senderAccountController.text;
//                     String receiverAccount = receiverAccountController.text;
//                     String amount = amountController.text;
//                     String remark = remarkController.text;
//                     String transactionPin = transactionPinController.text;
//
//                     // Add your transaction logic here
//
//                     // Print the input values for testing
//                     print("Sender's Account: $senderAccount");
//                     print("Receiver's Account: $receiverAccount");
//                     print("Amount: $amount");
//                     print("Remark: $remark");
//                     print("Transaction PIN: $transactionPin");
//                   },
//                   child: Container(
//                     height: 50.0,
//                     child: Center(
//                       child: Text(
//                         'Send',
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     elevation: 6.0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     primary: Colors.blue,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String label,
//       {bool obscureText = false,
//         TextInputType keyboardType = TextInputType.text,
//         FocusNode? focusNode,
//         String? errorText}) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         errorText: errorText, // Display error message if provided
//       ),
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       focusNode: focusNode, // Attach the FocusNode
//     );
//   }
// }
//
// // void main() {
// //   runApp(MaterialApp(
// //     home: TransactionPage(),
// //   ));
// // }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget _buildTextField(TextEditingController controller, String label,
    {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      FocusNode? focusNode,
      String? errorText}) {
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
  );
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

  String senderValidationMessage = "";
  String receiverValidationMessage = "";
  String amountValidationMessage = "";
  String pinValidationMessage = "";

  @override
  void initState() {
    super.initState();

    // Attach listeners to the fields to trigger validations when leaving the field
    senderAccountFocus.addListener(() {
      validateSenderAccount(senderAccountController.text, receiverAccountController.text);
    });

    receiverAccountFocus.addListener(() {
      validateReceiverAccount(receiverAccountController.text, senderAccountController.text);
    });

    amountFocus.addListener(() {
      validateAmount(amountController.text, senderAccountController.text);
    });
  }

  Future<void> validateSenderAccount(String accountNumber, String receiverNumber) async {
    try {
      // Replace this with your sender account validation logic
      // For example, query your Firestore collection for sender accounts
      // Reference to the Firestore collection where sender accounts are stored

      if(accountNumber == receiverNumber && (accountNumber != '' || receiverNumber != '')){
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
          senderValidationMessage = "";
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

  Future<void> validateReceiverAccount(String accountNumber, String senderNumber) async {
    try {
      // Replace this with your receiver account validation logic
      // For example, query your Firestore collection for receiver accounts
      // Reference to the Firestore collection where receiver accounts are stored
      if(accountNumber == senderNumber && (accountNumber != '' || senderNumber != '')){
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
          receiverValidationMessage = "";
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
      CollectionReference account = FirebaseFirestore.instance.collection('accounts');
      int parsedAmount = int.parse(amount);
      QuerySnapshot accountQuery = await account
          .where('account_no', isEqualTo: accountNumber)
          .get();
      if (parsedAmount <= 0) {
        setState(() {
          amountValidationMessage = "Amount must be non-negative.";
        });
      } else if(accountQuery.docs.isNotEmpty) {
        final document = accountQuery.docs[0].data();
        final balance = (document as Map)['balance'];
        if(balance >= parsedAmount) {
          setState(() {
            amountValidationMessage = "";
          });
        }
        else{
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

  Future<void> handlesubmit(String senderAccount, String receiverAccount, String amount, String remark, String transactionPin)async {
    final parsedAmount = int.parse(amount);
    final parsedpin = int.parse(transactionPin);
    DateTime now = new DateTime.now();
    CollectionReference account = FirebaseFirestore.instance.collection(
        'accounts');

    QuerySnapshot sender_account = await account.where(
        'account_no', isEqualTo: senderAccount).get();
    if (sender_account.docs.isNotEmpty) {
      final document = sender_account.docs[0].data();
      final pin = (document as Map)['transaction_pin'];
      if (pin == parsedpin) {
        CollectionReference transaction = FirebaseFirestore.instance.collection(
            'transaction');
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

        await sender_doc.update({'balance' : rem_bal});
        QuerySnapshot receiver = await account.where(
            'account_no', isEqualTo: receiverAccount).get();
        final DocumentReference receiver_doc = receiver.docs[0].reference;
        final receiver_doc_data = receiver.docs[0].data();
        final receiver_bal = (receiver_doc_data as Map)['balance'];
        final new_bal = receiver_bal + parsedAmount;
        await receiver_doc.update({'balance' : new_bal});
      }
    }
    else{
      setState(() {
        pinValidationMessage = "PIN is Incorrect";
      });
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
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.7,
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
                        focusNode: senderAccountFocus,
                        errorText: senderValidationMessage,
                      ),
                      SizedBox(height: 16.0),
                      _buildTextField(
                        receiverAccountController,
                        "Receiver's Account No",
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
                      _buildTextField(
                          transactionPinController, "Transaction PIN",
                          keyboardType: TextInputType.number,
                          obscureText: true,
                        errorText: pinValidationMessage),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          // Handle the transaction here
                          String senderAccount = senderAccountController.text;
                          String receiverAccount = receiverAccountController
                              .text;
                          String amount = amountController.text;
                          String remark = remarkController.text;
                          String transactionPin = transactionPinController.text;

                          // Add your transaction logic here
                          await handlesubmit(
                              senderAccount, receiverAccount, amount, remark,
                              transactionPin);

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
                          primary: Colors.blue,
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


