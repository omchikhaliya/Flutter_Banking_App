import 'package:flutter/material.dart';
import 'package:banking_application/models/cutomers.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  //final url = "meshivanshsingh.me";
 // final email = ;
  final phone = "90441539202"; // not real number :)
  final location = "Jamnagar, India";
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Customer;
    final baseurl = "assets/images/";
    final fullurl = data.url;
    return Scaffold(
        backgroundColor: Colors.blueGrey[800],
        body: SafeArea(
          minimum: const EdgeInsets.only(top: 100),
          child: Column(
            children: <Widget>[
               CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/$fullurl'),
              ),
              Text(
                data.name.toString(),
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Pacifico",
                ),
              ),

              SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                ),
              ),

              // we will be creating a new widget name info carrd

              InfoCard(text: data.mobileNo.toString(), icon: Icons.phone, onPressed: () async {}),
              InfoCard(text: data.dob.toString(), icon: Icons.web, onPressed: () async {}),
              InfoCard(
                  text: data.address.toString(),
                  icon: Icons.location_city,
                  onPressed: () async {}),
              InfoCard(text: data.email.toString(), icon: Icons.email, onPressed: () async {}),
            ],
          ),
        ));
  }
}

class InfoCard extends StatelessWidget {
  // the values we need
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onPressed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.teal,
          ),
          title: Text(
            text,
            style: TextStyle(
                color: Colors.teal,
                fontSize: 20,
                fontFamily: "Source Sans Pro"),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(Profile());
}
