class Account {
  String? account_no;
  String? account_status;
  String? account_type;
  int? balance;
  String? customer_ID;
  int? debit_card_no;
  bool? debitcard_available;
  bool? fd_available;
  String? nominee;
  int? transaction_pin;

  Account.nothing();
  Account({
    required this.account_no,
    required this.account_status,
    required this.account_type,
    required this.balance,
    required this.customer_ID,
    required this.debit_card_no,
    required this.debitcard_available,
    required this.fd_available,
    required this.nominee,
    required this.transaction_pin,
  });

  factory Account.fromMap(Map<dynamic, dynamic> map) {
    return Account(
      account_no: map['account_no'],
      account_status: map['account_status'],
      account_type: map['account_type'],
      balance: map['balance'],
      customer_ID: map['customer_ID'],
      debit_card_no: map['debit_card_no'],
      debitcard_available: map['debitcard_available'],
      fd_available: map['fd_available'],
      nominee: map['nominee'],
      transaction_pin : map['transaction_pin'],
    );
  }
}
