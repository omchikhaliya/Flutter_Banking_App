//import 'dart:js';

import 'package:banking_application/pages/QrPayment.dart';
import 'package:banking_application/pages/transaction.dart';
import 'package:flutter/material.dart';
import 'package:banking_application/pages/Loading.dart';
import 'package:banking_application/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:banking_application/pages/home.dart';
import 'package:banking_application/pages/authentication.dart';
import 'package:banking_application/pages/signup.dart';
import 'package:banking_application/pages/genrateqrcode.dart';
import 'package:banking_application/models/account.dart';
import 'package:banking_application/pages/profile.dart';
import 'package:banking_application/pages/scanqr.dart';


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
    '/genrate_qr': (context) => GenerateQRCode(),
    '/profile': (context) => Profile(),
    '/transaction': (context) => TransactionPage(),
    '/scan_qr': (context) => const Scanqr(),
    '/qr_payment' : (context) => const QRPayment(),
  }));
}