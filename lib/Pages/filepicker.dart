import 'package:flutter/material.dart';

class filepicker extends StatefulWidget {
  const filepicker({super.key});

  @override
  State<filepicker> createState() => _filepickerState();
}

class _filepickerState extends State<filepicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(child: Text("FIle Picker")),
    );
  }
}