import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final LocalAuthentication auth;
  bool _supportstate = false;
  String authen = "Authenticate Please";
  bool enableAuthentication = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      setState(() {
        _supportstate = isSupported;
      });
    });
    _loadEnableAuthenticationState();
  }

  Future<void> _loadEnableAuthenticationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isEnabled = prefs.getBool('enableAuthentication') ?? false;
    setState(() {
      enableAuthentication = isEnabled;
      authen = isEnabled ? "Authenticated" : "Authentication Disabled";
    });
  }

  // Function to save the state of enableAuthentication to SharedPreferences
  Future<void> _saveEnableAuthenticationState(bool isEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableAuthentication', isEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("App Lock"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.only(left: 30,right: 30),
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.deepPurpleAccent,
              // borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Enable Authentication",style: TextStyle(fontSize: 20,color: Colors.white),),
                  Switch(
                    value: enableAuthentication,
                    onChanged: (value) {
                      setState(() {
                        enableAuthentication = value;
                        authen = value
                            ? "Authenticate Please"
                            : "Authentication Disabled";
                      });
                      _saveEnableAuthenticationState(
                          value); // Save the state to SharedPreferences
                      if (value) {
                        _authenticate();
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
             Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                "$authen",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text("This authentication has been set in this device only, if you login in another device you have to setup your biometric again",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black54),),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticated",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      if (authenticated) {
        setState(() {
          authen = "Authenticated";
          enableAuthentication = true;
        });
      } else {
        setState(() {
          authen = "Authentication Failed";
          enableAuthentication = false;
        });
      }
    } catch (e) {
      print("Not authenticated, $e");
    }
  }

  Future<void> _getavailablebiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print("List: $availableBiometrics");
    if (!mounted) {
      return;
    }
  }
}
