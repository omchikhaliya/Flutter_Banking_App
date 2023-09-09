import 'package:flutter/material.dart';
//import 'package:banking_application/pages/Loading.dart';
import 'package:banking_application/pages/login_page.dart';

void main() {
  runApp(MaterialApp(
      routes:{
        //'/' : (context) => Loading(),
        '/' : (context) => LoginPage(),

      }
  ));
}



