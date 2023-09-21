import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name1 = "";
  String CustId = "";

  void setvariables() async {
    super.initState();
    super.initState();
    final pref = await SharedPreferences.getInstance();
    name1 = pref.getString('name') ?? '';
    CustId = pref.getString('id') ?? '';
    // pref.setString('name', customerName);
    // pref.setString('id', customerId);
  }

  @override
  void initState() {
    setvariables();
  }

  bool isAccountDetailsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bank'),
        actions: <Widget>[
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
                      child: const Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.account_circle),
                            title: Text('Account Holder'),
                            subtitle: Text('John Doe'),
                          ),
                          ListTile(
                            leading: Icon(Icons.account_balance),
                            title: Text('Account Number'),
                            subtitle: Text('1234567890'),
                          ),
                          ListTile(
                            leading: Icon(Icons.credit_card),
                            title: Text('Card Number'),
                            subtitle: Text('**** **** **** 1234'),
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
                    // Add transfer money functionality here
                  },
                  icon: Icon(Icons.send),
                  label: Text('Transfer Money'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add view all accounts functionality here
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
