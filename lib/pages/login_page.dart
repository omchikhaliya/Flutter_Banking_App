import 'package:banking_application/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:banking_application/pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No user found for that email."),
          ),
        );
      } else if (e.code == 'wrong-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong password provided for that user"),
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Future<void> authenticateWithBiometrics() async {
    final localAuth = LocalAuthentication();

    try {
      bool biometricsAvailable = await localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      if (biometricsAvailable && availableBiometrics.isNotEmpty) {
        bool authenticated = await localAuth.authenticate(
          localizedReason: 'Authenticate to access the app',
          // useErrorDialogs: true,
          // stickyAuth: true, // iOS only; enables biometric lock for the app
        );

        if (authenticated) {
          // Authentication successful, you can proceed to the app's main content
          // For example, navigate to the main screen.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          // Authentication failed, show an error message or handle it accordingly.
          // For example, you can show a snackbar or display an error message.
        }
      } else {
        // Biometrics are not available on this device, or the user hasn't set them up.
        // You can provide an alternative authentication method here.
      }
    } catch (e) {
      // Handle errors, such as local_auth plugin not installed or permission denied.
      print('Error during biometric authentication: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: (Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: OverflowBar(
              overflowSpacing: 20,
              children: [
                TextFormField(
                  controller: _email,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Email is empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  controller: _password,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'password is empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Password"),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // signInWithEmailAndPassword();
                        authenticateWithBiometrics();
                        print("validation is done");
                      }
                    },
                    child: const Text('Login'),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
