

import 'package:flutter/material.dart';
import 'package:med_sheet/API/google_signin_api.dart';
import 'package:med_sheet/Login%20Screen/LoginScreen.dart';

class reports extends StatefulWidget {
  const reports({super.key});

  @override
  State<reports> createState() => _reportsState();
}

class _reportsState extends State<reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings Page"),
     actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: (){
            GoogleSignInApi.logout();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
          },
          child: Icon(Icons.logout)),
      )
     ],   backgroundColor: Colors.deepOrangeAccent,
     centerTitle: true,
        
      ),
      body: Center(
        child: Text("Reports"),
      ),
    );
  }
}