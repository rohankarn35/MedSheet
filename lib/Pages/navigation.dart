import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:med_sheet/Pages/filepicker.dart';
import 'package:med_sheet/Pages/homescreen.dart';
import 'package:med_sheet/Pages/reports.dart';

class Navigation extends StatefulWidget {
  final GoogleSignInAccount user;
  Navigation({Key? key, required this.user}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // final GoogleSignInAccount useraccount = user;
  late GoogleSignInAccount user;

  int _selectedindex =  1;
   late List<Widget> screens;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      user = widget.user;
    screens = [
      filepicker(),
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
        color: Colors.red,
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