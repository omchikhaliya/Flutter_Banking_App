import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String name1="";
  String CustId = "";

  @override
  void initstate()
  async {
    super.initState();
    final pref = await SharedPreferences.getInstance();
    name1 = pref.getString('name') ?? '';
    CustId = pref.getString('id') ?? '';
    // pref.setString('name', customerName);
    // pref.setString('id', customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Home page'),
        ),
      ),
      body:  Center(
        child: Text('Welcome to home page ${name1}'),
      ),
    );
  }
}
