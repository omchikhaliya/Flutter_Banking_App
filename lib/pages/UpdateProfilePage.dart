import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final customer = ModalRoute.of(context)?.settings.arguments as Customer;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                // Handle update logic here
                String updatedEmail = _emailController.text;
                int? updatedMobile = int.tryParse(_mobileController.text);
                String updatedAddress = _addressController.text;

                final pref = await SharedPreferences.getInstance();
                final CustId = pref.getString('id') ?? '';
                if(updatedAddress != ""){
                  CollectionReference customers = FirebaseFirestore.instance.collection('customers');

                  QuerySnapshot customerQuery = await customers
                      .where('customer_ID', isEqualTo: CustId)
                      .get();

                  if (customerQuery.docs.isNotEmpty) {
                    // Get the reference to the first document with matching customer_ID
                    DocumentReference customerDocRef = customers.doc(customerQuery.docs[0].id);

                    // Update the 'address' field in the document
                    await customerDocRef.update({
                      'address': updatedAddress,
                    });

                    print('Address updated successfully.');
                  } else {
                    print('Customer not found.');
                  }

                }
                if(updatedMobile != ""){
                  CollectionReference customers = FirebaseFirestore.instance.collection('customers');

                  QuerySnapshot customerQuery = await customers
                      .where('customer_ID', isEqualTo: CustId)
                      .get();

                  if (customerQuery.docs.isNotEmpty) {
                    // Get the reference to the first document with matching customer_ID
                    DocumentReference customerDocRef = customers.doc(customerQuery.docs[0].id);

                    // Update the 'address' field in the document
                    await customerDocRef.update({
                      'mobile_no': updatedMobile,
                    });

                    print('Mobile No updated successfully.');
                  } else {
                    print('Customer not found.');
                  }
                }
                if(updatedEmail != ""){
                  CollectionReference customers = FirebaseFirestore.instance.collection('customers');

                  QuerySnapshot customerQuery = await customers
                      .where('customer_ID', isEqualTo: CustId)
                      .get();

                  if (customerQuery.docs.isNotEmpty) {
                    // Get the reference to the first document with matching customer_ID
                    DocumentReference customerDocRef = customers.doc(customerQuery.docs[0].id);

                    // Update the 'address' field in the document
                    await customerDocRef.update({
                      'email': updatedEmail,
                    });

                    print('Email-ID updated successfully.');
                  } else {
                    print('Customer not found.');
                  }
                }

                // Show a confirmation dialog or navigate back to the previous screen
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Profile Updated'),
                      content: Text('Your profile has been updated successfully.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            //Navigator.pushNamed(context, '/profile');
                            Navigator.of(context).pop();
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(home: UpdateProfilePage()));
