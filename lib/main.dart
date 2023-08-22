import 'package:flutter/material.dart';
import 'package:med_sheet/Login%20Screen/LoginScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedSheet',
      home: const LoginScreen()
    );
  }
}
