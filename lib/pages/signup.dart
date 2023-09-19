import 'dart:ffi';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:banking_application/pages/Loading.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool showOtpField = false;
  bool verifyOtpField = false;
  TextEditingController otpController = TextEditingController();
  TextEditingController otpverifyController = TextEditingController();
  TextEditingController setpinController = TextEditingController();
  TextEditingController confirmsetpinController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();

  EmailOTP myauth = EmailOTP();

  final _formKey = GlobalKey<FormState>(); // GlobalKey for form validation


  final CollectionReference customers = FirebaseFirestore.instance.collection('customers');
  //final customersRef = FirebaseFirestore.instance.collection('customers');

  Future loginCustomer(String customerId) async {

    try {
      /*
      * print(customersRef);
      final query = customersRef.where('customer_ID', isEqualTo: '111111');
      print("query : $query");

      query.get().then((snapshot) {
        if (snapshot.docs.isEmpty) {
          print("Customer ID not found");
        } else {
          print("Customer ID found");
        }
      });
      */
        print(customerId);
        final QuerySnapshot<Object?> querySnapshot = await customers.where('customer_ID', isEqualTo: customerId).get();
      print("inside ");
      print(querySnapshot.docs);
      if (querySnapshot.docs.isNotEmpty) {
        // Customer with the given ID found
        // final email = querySnapshot.docs[0].data()?['email'];
        //final email1 = querySnapshot.docs[0].data();
        final document = querySnapshot.docs[0].data();
        final email1 = (document as Map)['email'];
        print('Email: $email1');

        return email1;

      } else {
        print('Customer not found');
        return null;
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }


  void sendOTP(String email) async {
    // Implement OTP sending logic here
    myauth.setConfig(
        appEmail: "bharatnationalbank@gmail.com",
        appName: "BHARAT NATIONAL BANK",
        userEmail: email,
        otpLength: 4,
        otpType: OTPType.digitsOnly
    );
    if (await myauth.sendOTP() == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        content: Text("OTP has been sent"),
      ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        content: Text("Oops, OTP send failed"),
      ));
    }
    setState(() {
      showOtpField = true;
    });

  }

  void verifyOTP() async {
    if (await myauth.verifyOTP(otp: otpverifyController.text) == true) {
      verifyOtpField = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
    content: Text("OTP is verified"),
    ));
    } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
    content: Text("Invalid OTP"),
    ));
    }
    setState(() {

    });
  }

  void savepin() async
  {
    try{
      final customerId = customerIdController.text.trim();
      final pin = setpinController.text.trim();

      final QuerySnapshot<Object?> querySnapshot =
      await customers.where('customer_ID', isEqualTo: customerId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentReference documentRef = querySnapshot.docs[0].reference;

        final name2 = querySnapshot.docs[0].data();
        final customerName = (name2 as Map)['name'];
        await documentRef.update({
          'MPIN': pin,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("PIN updated successfully"),

        ));
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('name', customerName);
        pref.setString('id', customerId);

        String name = pref.getString('name')!;
        String ID = pref.getString('id')!;

        print(name);
        print(ID);

        Navigator.pushReplacementNamed(context,'/login_page',arguments: {'name' : customerName,'id': customerId});
      } else {
        print('Customer not found');
      }
    }
    catch(error){
      print('Error: ${error.toString()}');
    }


  }

  @override
  void dispose() {
    otpController.dispose();
    otpverifyController.dispose();
    setpinController.dispose();
    confirmsetpinController.dispose();
    emailController.dispose();
    customerIdController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sign Up')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Set the GlobalKey<FormState> for form validation
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    // Add more complex email validation logic here if needed
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: customerIdController,
                  decoration: InputDecoration(labelText: 'Customer ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Customer ID is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, proceed with verification and signup
                      print("email :");
                      print(emailController.text.trim());
                      final email = await loginCustomer(customerIdController.text.trim());
                      if (email == emailController.text.trim()) {
                        sendOTP(email);
                      } else {
                        // Implement OTP verification and signup logic here
                        // You can compare otpController.text with the expected OTP
                      }
                    }
                  },
                  child: Text("Get OTP"),
                ),
                SizedBox(height: 16.0),
                if (showOtpField)
                  TextFormField(
                    controller: otpverifyController,
                    decoration: InputDecoration(labelText: 'Enter OTP'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'OTP is required';
                      }
                      // Add OTP format validation here if needed
                      return null;
                    },
                  ),
                SizedBox(
                  height: 16,
                ),
                if (showOtpField)
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed with verification and signup
                        if (!verifyOtpField) {
                          verifyOTP();
                        } else {
                          // Implement OTP verification and signup logic here
                        }
                      }
                    },
                    child: Text("Verify OTP"),
                  ),
                SizedBox(height: 16.0),
                if (verifyOtpField)
                  TextFormField(
                    controller: setpinController,
                    decoration: InputDecoration(labelText: 'Set PIN'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Set PIN is required';
                      }
                      // Add PIN format validation here if needed
                      return null;
                    },
                  ),
                SizedBox(height: 16.0),
                if (verifyOtpField)
                  TextFormField(
                    controller: confirmsetpinController,
                    decoration: InputDecoration(labelText: 'Confirm PIN'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm PIN is required';
                      }
                      if (value != setpinController.text) {
                        return 'PINs do not match';
                      }
                      return null;
                    },
                  ),
                SizedBox(
                  height: 16,
                ),
                if (verifyOtpField)
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed with signup
                        // Implement signup logic here
                        if(setpinController.text == confirmsetpinController.text)
                          {
                            savepin();
                          }
                        else
                          {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid PIN"),
                            ));
                          }
                      }
                    },
                    child: Text("Sign Up"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
