import 'package:banking_application/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class Authentication {
  static final _auth = LocalAuthentication();
  static Future<bool> canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
  static Future<bool> authentication() async {
    try {
      final availableBiometrics = await _auth.getAvailableBiometrics();
      print('Available biometrics: $availableBiometrics');
      if (!await canAuthenticate()) return false;
      return await _auth.authenticate(
        localizedReason: "get into the app",
        options: const AuthenticationOptions(
        //Shows error dialog for system-related issues
        useErrorDialogs: true,
        //If true, auth dialog is show when app open from background
        stickyAuth: true,
        //Prevent non-biometric auth like such as pin, passcode.
        biometricOnly: true,
      ),
      );
    } catch (e) {
      print('error $e');
      return false;
    }
  }
}

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 28,
              ),
              Text(
                "use your fingerprint to log into the app",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 28,
              ),
              Divider(
                color: Colors.white,
              ),
              SizedBox(
                height: 28,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    bool auth = await Authentication.authentication();
                    print("can authenticate: $auth");
                    if (auth) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    }
                  },
                  icon: Icon(Icons.fingerprint),
                  label: Text("Authenticate")),
            ],
          ),
        ),
      ),
    );
  }
}
