class Customer {
  String address;
  String dob;
  String name;
  String mobileNo;
  String panNo;
  String aadharCardNo;
  String customerID;
  String mPin;
  String email;

  Customer({
    required this.address,
    required this.dob,
    required this.name,
    required this.mobileNo,
    required this.panNo,
    required this.aadharCardNo,
    required this.customerID,
    required this.mPin,
    required this.email,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      address: map['address'],
      dob: map['dob'],
      name: map['name'],
      mobileNo: map['mobile_no'],
      panNo: map['pan_no'],
      aadharCardNo: map['aadhar_card_no'],
      customerID: map['customer_ID'],
      mPin: map['MPIN'],
      email: map['email'],
    );
  }
}
