import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  String? sender_account_no;
  String? receiver_account_no;
  String? remarks;
  int? amount;
  Timestamp? date;

  Transactions.nothing();
  Transactions({
    required this.sender_account_no,
    required this.receiver_account_no,
    required this.remarks,
    required this.amount,
    required this.date,
  });

  factory Transactions.fromMap(Map<dynamic, dynamic> map) {
    return Transactions(
      sender_account_no: map['sender_account_no'],
      receiver_account_no: map['receiver_account_no'],
      remarks: map['remarks'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}
