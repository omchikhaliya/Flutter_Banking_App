import 'package:banking_application/pages/transaction.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:banking_application/models/account.dart';
import 'package:banking_application/models/transactions.dart';
import 'package:intl/intl.dart';

import '../models/cutomers.dart';


Account account_info = Account.nothing();
String sender_name = "";
String receiver_name = "";
class transactionHistory extends StatefulWidget {
  const transactionHistory({Key? key});

  @override
  State<transactionHistory> createState() => _transactionHistoryState();
}

class _transactionHistoryState extends State<transactionHistory> {
  @override
  Widget build(BuildContext context) {

    Future<void> fetchname(String? sender_account_no, String? receiver_account_no)async{

      CollectionReference account = FirebaseFirestore.instance.collection('accounts');
      QuerySnapshot accountQuery = await account
          .where('account_no', isEqualTo: sender_account_no)
          .get();
      final document1 = accountQuery.docs[0].data() as Map;
      final account_info1 = Account.fromMap(document1);
      CollectionReference customer = FirebaseFirestore.instance.collection('customers');
      QuerySnapshot customerQuery = await customer
          .where('customer_ID', isEqualTo: account_info1.customer_ID).get();
      final document2 = customerQuery.docs[0].data() as Map;
      final customer_info1 = Customer.fromMap(document2);
      sender_name = customer_info1.name!;
      print(sender_name);
      accountQuery = await account
          .where('account_no', isEqualTo: receiver_account_no)
          .get();
      final document3 = accountQuery.docs[0].data() as Map;
      final account_info2 = Account.fromMap(document3);
      customerQuery = await customer
          .where('customer_ID', isEqualTo: account_info2.customer_ID).get();
      final document4 = customerQuery.docs[0].data() as Map;
      final customer_info2 = Customer.fromMap(document4);
      receiver_name = customer_info2.name!;
      print(receiver_name);
      // List<String> lst = [sender_name, receiver_name];
      // return lst;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: FutureBuilder<List<Transactions>>(
        // Assuming you have a method to fetch transactions from Firestore
        future: fetchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No transactions available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Transactions transaction = snapshot.data![index];
                bool isSent = transaction.sender_account_no == account_info.account_no;

                //Convert the timestamp to DateTime
                DateTime transactionDate = transaction.date!.toDate();

                // fetchname(transaction.sender_account_no, transaction.receiver_account_no);

                // Format the DateTime object to a human-readable date string
                String formattedDate = DateFormat.yMMMd().format(transactionDate);

                Color transactionColor = isSent ? Colors.red : Colors.green;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ListTile(
                    title: Text(
                      'Transaction ID: ${transaction.hashCode}',
                      style: TextStyle(color: transactionColor), // Set text color here
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sender: ${transaction.sender_account_no}'),
                        Text('Receiver: ${transaction.receiver_account_no}'),
                        Text('Amount: \₹${transaction.amount}'),
                        Text('Remark: ${transaction.remarks}'),
                        Text('Date: $formattedDate'), // Display formatted date
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Transactions>> fetchTransactions() async {
    final pref = await SharedPreferences.getInstance();
    final CustId = pref.getString('id') ?? '';
    CollectionReference account = FirebaseFirestore.instance.collection('accounts');
    QuerySnapshot accountQuery = await account
        .where('customer_ID', isEqualTo: CustId)
        .get();
    final document1 = accountQuery.docs[0].data() as Map;
    print("--------------------");
    print(document1);
    account_info = Account.fromMap(document1);
    CollectionReference transaction = FirebaseFirestore.instance.collection('transaction');
    QuerySnapshot transactionQuery = await transaction
        .where('sender_account_no', isEqualTo: account_info.account_no)
        .get();
    QuerySnapshot receivedTransactionsQuery = await transaction
        .where('receiver_account_no', isEqualTo: account_info.account_no)
        .get();
    List<Transactions> transactions = [];

    for(var document in transactionQuery.docs){
      final doc1 = document.data() as Map;
      final transactioninfo = Transactions.fromMap(doc1);
      // DateTime? transactionDate = transactioninfo.date;
      // transactioninfo.date = DateFormat.yMMMd().format(transactionDate!) as DateTime?;
      transactions.add(transactioninfo);
    }
    for (var document in receivedTransactionsQuery.docs) {
      final doc1 = document.data() as Map;
      final transactionInfo = Transactions.fromMap(doc1);
      // DateTime? transactionDate = transactionInfo.date;
      // transactionInfo.date = DateFormat.yMMMd().format(transactionDate!) as DateTime?;
      transactions.add(transactionInfo);
    }
    print(transactions);
    transactions.sort((a, b) => a.date!.toDate().compareTo(b.date!.toDate()));
    transactions = transactions.reversed.toList();
    return transactions;
  }
}
