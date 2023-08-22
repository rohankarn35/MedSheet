

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../API/google_signin_api.dart';
import '../Pages/mainpage.dart';

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
     backgroundColor: Colors.white,
     body: SafeArea(
       child: Column(
        children: [
          SizedBox(height: height,),
          Center(
            child: Image.asset("asset/logos/logo.png",height: 130, width: 130,)
            ),
            
          
          // const SizedBox(height: 8,),
          // const Text("MedSheet",style: TextStyle(fontSize: 30),),
          const SizedBox(height: 10,),
          const Text("Digital Sheet of your medical reports!!",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,  ),),
          SizedBox(height: height*1.4,),
          InkWell(
            
            child: InkWell(
              onTap: signin,
              child: Center(
                child: Container(
                          
                  height: 75,
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

    Future signin()  async{
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unable to SignIn")));
      
    }else{
      print(user);

    Navigator.pushReplacement( context, MaterialPageRoute(builder: (context)=> MainPage(user: user)));

   }
  }
}