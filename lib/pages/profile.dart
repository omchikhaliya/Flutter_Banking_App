import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
        ),
        body: UserProfileBody(),
      ),
    );
  }
}

class UserProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Picture
          CircleAvatar(
            radius: 50,
            // You can load the user's profile picture here
            backgroundImage: AssetImage('assets/profile_picture.png'),
          ),

          SizedBox(height: 16),

          // User's Name
          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          // Account Information
          Text(
            'Account Number: XXXXXXXX',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Address: 123 Main Street, City',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'PAN Card Number: ABCDE1234F',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Debit Card: XXXX-XXXX-XXXX-1234',
            style: TextStyle(fontSize: 16),
          ),

          SizedBox(height: 24),

          // You can add more user-related information here
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserProfilePage();
  }
}
