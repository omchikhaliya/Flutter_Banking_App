import 'package:flutter/material.dart';
import 'package:banking_application/pages/Loading.dart';
import 'package:banking_application/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:banking_application/pages/home.dart';
import 'package:banking_application/pages/authentication.dart';
import 'package:banking_application/pages/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(

      routes: {
    '/' : (context) => Loading(),
    //'/' : (context) => Signup(),
    '/login_page': (context) => const LoginPage(),
    '/home': (context) => const Home(),
    '/sign_up': (context) => const Signup(),
  }));
}