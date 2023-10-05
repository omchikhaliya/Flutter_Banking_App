import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:banking_application/models/cutomers.dart';
import 'package:banking_application/models/account.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String name1="";
  String CustId = "";
  String account_holder = "";
  String account_no = "";
  String card_no = "";
  Customer customer_info = Customer.nothing();
  Account account_info = Account.nothing();


  void setvariables() async {
    super.initState();
    super.initState();
    final pref = await SharedPreferences.getInstance();
    name1 = pref.getString('name') ?? '';
    CustId = pref.getString('id') ?? '';
    // pref.setString('name', customerName);
    // pref.setString('id', customerId);

    CollectionReference customer = FirebaseFirestore.instance.collection('customers');
    QuerySnapshot customerQuery = await customer
        .where('customer_ID', isEqualTo: CustId)
        .get();
    final document = customerQuery.docs[0].data() as Map;
    account_holder = (document)['name'];
    CollectionReference account = FirebaseFirestore.instance.collection('accounts');
    QuerySnapshot accountQuery = await account
        .where('customer_ID', isEqualTo: CustId)
        .get();
    customer_info = Customer.fromMap(document);
    final document1 = accountQuery.docs[0].data() as Map;
    account_info = Account.fromMap(document1);

  }

  @override
  void initState() {
    setvariables();
  }

  bool isAccountDetailsExpanded = false;

  Future<Customer> fetchuserdata() async {
    CollectionReference customer = FirebaseFirestore.instance.collection('customers');
    QuerySnapshot customerQuery = await customer
        .where('customer_ID', isEqualTo: CustId)
        .get();
    final document = customerQuery.docs[0].data() as Map;
    final data = Customer.fromMap(document);
    return data;
  }

  @override
  Widget build(BuildContext context){


    return Scaffold(
      appBar: AppBar(
        title: Text('My Bank'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: ()async {
              Customer customer = await fetchuserdata();
              Navigator.pushNamed(context, '/profile', arguments: customer);
              //Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add settings functionality here
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'My Bank',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Account Balance'),
                onTap: () {
                  // Toggle account details
                  setState(() {
                    isAccountDetailsExpanded = !isAccountDetailsExpanded;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Transaction History'),
                onTap: () {
                  // Navigate to transaction history page
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionHistoryPage()));
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Account Balance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: isAccountDetailsExpanded
                            ? Icon(
                                Icons.keyboard_arrow_up,
                                key: Key('up'),
                              )
                            : Icon(
                                Icons.keyboard_arrow_down,
                                key: Key('down'),
                              ),
                      ),
                      onTap: () {
                        // Toggle account details
                        setState(() {
                          isAccountDetailsExpanded = !isAccountDetailsExpanded;
                        });
                      },
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: isAccountDetailsExpanded ? 220 : 0,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.account_circle),
                            title: Text('Account Holder'),
                            subtitle: Text(customer_info.name.toString()),
                          ),
                          ListTile(
                            leading: Icon(Icons.account_balance),
                            title: Text('Account Number'),
                            subtitle: Text(account_info.account_no.toString()),
                          ),
                          ListTile(
                            leading: Icon(Icons.credit_card),
                            title: Text('Card Number'),
                            subtitle: Text(account_info.debit_card_no.toString()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/genrate_qr');
                    // Add transfer money functionality here
                  },
                  icon: Icon(Icons.qr_code),
                  label: Text('Qr code'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/scan_qr');
                  },
                  icon: Icon(Icons.qr_code_scanner),
                  label: Text('scan & pay'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {

                    Navigator.pushNamed(context, '/transaction');
                  },
                  icon: Icon(Icons.send),
                  label: Text('Transfer Money'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add transfer money functionality here
                  },
                  icon: Icon(Icons.account_balance_wallet),
                  label: Text('View All Accounts'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    // Add request digital loan functionality here
                  },
                  icon: Icon(Icons.money),
                  label: Text('Digital Loan'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add request services functionality here
                  },
                  icon: Icon(Icons.message),
                  label: Text('Request Services'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add floating action button functionality here
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TransactionHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: Center(
        child: Text('Transaction history will be displayed here.'),
      ),
    );
  }
}
