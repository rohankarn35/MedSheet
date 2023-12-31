import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:med_sheet/Pages/homescreen.dart';
import 'package:med_sheet/Pages/reports.dart';
import 'package:med_sheet/Pages/upload.dart';

class Navigation extends StatefulWidget {
  final User? user;
  Navigation({Key? key, required this.user}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // final GoogleSignInAccount useraccount = user;
  late User? user = widget.user; 

  int _selectedindex =  1;
   late List<Widget> screens;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      user = user;
    screens = [
      Upload(user: user),
      HomeScreen(user: user),
      reports()
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedindex],
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (value) {
          setState(() {
            _selectedindex = value;
          });
        },
        index: _selectedindex,
        color: Colors.deepPurpleAccent,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 350),
        animationCurve: Curves.easeOut,
        items: [
        Icon(Icons.document_scanner_rounded),

        Icon(Icons.home),

        Icon(Icons.settings),

      ]),

    );
  }
}