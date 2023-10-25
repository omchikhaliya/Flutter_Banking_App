import 'package:banking_application/pages/QrPayment.dart';
import 'package:banking_application/pages/UpdateProfilePage.dart';
import 'package:banking_application/pages/transaction.dart';
import 'package:banking_application/pages/transactionHistory.dart';
import 'package:flutter/material.dart';
import 'package:banking_application/pages/Loading.dart';
import 'package:banking_application/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:banking_application/pages/home.dart';
import 'package:banking_application/pages/signup.dart';
import 'package:banking_application/pages/genrateqrcode.dart';
import 'package:banking_application/pages/profile.dart';
import 'package:banking_application/pages/scanqr.dart';
import 'package:banking_application/pages/QrPay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
    // '/' : (context) => Signup(),
    '/' : (context) => Loading(),
    '/login_page': (context) => const LoginPage(),
    '/home': (context) => const Home(),
    '/sign_up': (context) => const Signup(),
    '/genrate_qr': (context) => GenerateQRCode(),
    '/profile': (context) => Profile(),
    '/transaction': (context) => TransactionPage(),
    '/scan_qr': (context) => const Scanqr(),
        '/transactionHistory' : (context) => const transactionHistory(),
        '/updateProfile' : (context) => UpdateProfilePage(),
    '/qr_payment' : (context) => QRPayment(),
    '/qr_pay' : (context) => QrPay(),
  }));
}