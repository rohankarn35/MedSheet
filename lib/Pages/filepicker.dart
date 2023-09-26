import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class filepicker extends StatefulWidget {
  const filepicker({super.key});

  @override
  State<filepicker> createState() => _filepickerState();
}

class _filepickerState extends State<filepicker> {

  Future<String?> uploadPdf(String filename, File file) async{
  final reference =  FirebaseStorage.instance.ref().child("reports/$filename.pdf");
  final UploadTask = reference.putFile(file);
  await UploadTask.whenComplete(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: ListView.builder(
        itemCount: 10,
        
        
        itemBuilder: (context, index){
          return Padding(padding: const EdgeInsets.all(8.0),
          child: InkWell(onTap: (){},
          
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network("https://play-lh.googleusercontent.com/9XKD5S7rwQ6FiPXSyp9SzLXfIue88ntf9sJ9K250IuHTL7pmn2-ZB0sngAX4A2Bw4w",
                height: 120,
                width: 100,
                ),
                Text("Your Report", style: TextStyle(fontSize: 10),)
              ],
            ),
          ),
          ),
          
          );
        })
    );
  }
}