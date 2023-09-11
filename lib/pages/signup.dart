import 'package:flutter/material.dart';

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

  final _formKey = GlobalKey<FormState>(); // GlobalKey for form validation

  void sendOTP() {
    // Implement OTP sending logic here
    setState(() {
      showOtpField = true;
    });
  }

  void verifyOTP() {
    setState(() {
      verifyOtpField = true;
    });
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, proceed with verification and signup

                      if (!showOtpField) {
                        sendOTP();
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
