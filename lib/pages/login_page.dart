import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:banking_application/pages/authentication.dart';
import 'package:banking_application/pages/home.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool islogin = false;
  final CollectionReference customers = FirebaseFirestore.instance.collection('customers');

  //final LocalStorage storage = new LocalStorage('name.json');

  //storage.setItem('name_' ,'devanshu');

  signInWithEmailAndPassword() async {
    try {
      print(_email);
      print(_password);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);

      islogin = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        islogin = false;
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No user found for that email."),
          ),
        );
      } else if (e.code == 'wrong-password') {
        islogin = false;
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong password provided for that user"),
          ),
        );
      }
    }
  }

  Future<bool> verifyCustomer(String customerId, String pin) async {
    try {
      final QuerySnapshot<Object?> querySnapshot =
      await customers.where('customer_ID', isEqualTo: customerId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot<Object?> documentSnapshot = querySnapshot.docs[0];
        final customerData = documentSnapshot.data() as Map<String, dynamic>;
        final storedPin = customerData['pin'].toString();

        // Compare the provided PIN with the stored PIN
        if (pin == storedPin) {
          return true; // PIN is correct
        }
      }

      return false; // Customer not found or PIN is incorrect
    } catch (e) {
      print('Error verifying customer: $e');
      return false; // Return false if there is an error
       }
  }

  Map<dynamic,dynamic> data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isEmpty ? ModalRoute.of(context)?.settings.arguments as Map :data;
    print(data);

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
                        Text(
                            "Welcome, Mr. ${data['name']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25.0,
                          ),
                        ),
                        Text(
                          "Enter your pin to login",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 21.0,
                          ),
                        ),
                        TextFormField(
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0,
                          ),
                          controller: _email,
                          /*validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Email is empty';
                            }*/
                            //return null;
                          //},
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
                              const InputDecoration(hintText: "Pin"),
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
                                      context, '/home',arguments: {'name' : data['name']});
                                }
                              },
                              icon: Icon(Icons.fingerprint),
                              label: Text(
                                "Authenticate",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                ),
                              )),
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

                                if(_email != "") {
                                  signInWithEmailAndPassword();
                                  //print("validation is done");
                                }
                                else
                                  {
                                    verifyCustomer(data['id'], _password.text);
                                  }
                                if (islogin) {
                                  Navigator.pushReplacementNamed(
                                      context, '/home',arguments: {'name' : data['name']});
                                }
                              }
                            },
                            child: const Text(
                              'Login',
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
