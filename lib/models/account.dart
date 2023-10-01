class Account {
  String accountNo;
  String accountStatus;
  double balance;
  String customerID;
  String debitCardNo;
  bool debitCardAvailable;
  bool fdAvailable;
  String nominee;
  String transactionPin;

  Account({
    required this.accountNo,
    required this.accountStatus,
    required this.balance,
    required this.customerID,
    required this.debitCardNo,
    required this.debitCardAvailable,
    required this.fdAvailable,
    required this.nominee,
    required this.transactionPin,
  });
}
