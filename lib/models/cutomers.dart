class Customer {
  String? address;
  String? dob;
  String? name;
  int mobileNo = 0;
  String? panNo;
  int aadharCardNo = 0;
  String? customerID;
  String? mPin;
  String? email;
  String? url;

  Customer.nothing();
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
    required this.url
  });

  factory Customer.fromMap(Map<dynamic, dynamic> map) {
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
      url : map['url'],
    );
  }
}
