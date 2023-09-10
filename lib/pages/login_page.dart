import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:banking_application/pages/authentication.dart';
import 'package:banking_application/pages/home.dart';
import 'package:flutter/services.dart';

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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/blue2.jpg'),
          fit: BoxFit.cover,
        )),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 50.0, sigmaX: 50.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                shadowColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: OverflowBar(
                      overflowSpacing: 20,
                      children: [
                        TextFormField(
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0,
                          ),
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
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0,
                          ),
                          controller: _password,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'password is empty';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(hintText: "Password"),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                              onPressed: () async {
                                bool auth =
                                    await Authentication.authentication();
                                print("can authenticate: $auth");
                                if (auth) {
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                }
                              },
                              icon: Icon( Icons.fingerprint),
                              label: Text("Authenticate",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                ),
                              )
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signInWithEmailAndPassword();
                                print("validation is done");
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }
                            },
                            child: const Text('Login',
                              style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
