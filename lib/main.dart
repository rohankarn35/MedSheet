import 'package:flutter/material.dart';
import 'package:med_sheet/Login%20Screen/LoginScreen.dart';
import 'package:med_sheet/Pages/homescreen.dart';
import 'package:med_sheet/Pages/mainpage.dart';
import 'package:med_sheet/Pages/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedSheet',
      home:  LoginScreen()
    );
  }
}

