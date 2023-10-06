

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:med_sheet/Pages/homescreen.dart';
import 'package:med_sheet/Pages/navigation.dart';
import 'package:med_sheet/Pages/stream.dart';

import '../API/google_signin_api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.25;
    return Scaffold(
     backgroundColor: Color.fromARGB(255, 220, 213, 238),
     body: SafeArea(
       child: Column(
        children: [
          SizedBox(height: height,),
          Center(
            child: Image.asset("asset/logos/logo.png",height: 130, width: 130,)
            ),
            
          
          // const SizedBox(height: 8,),
          // const Text("MedSheet",style: TextStyle(fontSize: 30),),
          const SizedBox(height: 16,),
          const Text("Digital Sheet of your medical reports!!",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,  ),),
          SizedBox(height: height*1.4,),
          InkWell(
            
            child: InkWell(
              onTap: () async{
                   
              GoogleSignInApi.login();
             
              
              
              print("CLicked");
              },
              child: Center(
                child: Container(
                          
                  height: 70,
                  width: 300,
                  decoration: BoxDecoration(color: Colors.black,
                  borderRadius: BorderRadius.circular(40)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
              
                    children: [
                      const  SizedBox(width: 30,),
                      Image.asset("asset/logos/google.png",height: 50,width: 50,),
                      const SizedBox(width: 10,),
                      const Text("Continue with Google",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600, color: Colors.white),)
                    ],
                  )),
              ),
            )),

          
        ],
       ),
     ),
    );
    
  }

  
}