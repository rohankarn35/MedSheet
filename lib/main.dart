import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:med_sheet/Login%20Screen/LoginScreen.dart';
import 'package:med_sheet/Pages/applock.dart';
import 'package:med_sheet/Pages/feedback.dart';
import 'package:med_sheet/Pages/stream.dart';
import 'package:med_sheet/Pages/userinfo.dart';

import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
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
      home: AppLock()
    );
  }
}

