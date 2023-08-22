import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:med_sheet/API/google_signin_api.dart';
import 'package:med_sheet/Login%20Screen/LoginScreen.dart';

class MainPage extends StatelessWidget {
  final GoogleSignInAccount user;
  
  const MainPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MedSheet"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              await GoogleSignInApi.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Icon(Icons.logout_rounded,))
        ],

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 110,
              backgroundImage: AssetImage("${user.photoUrl}"),
            ),
             SizedBox(height: 10,),
             Text("${user.displayName}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600,),),
             SizedBox(height: 10,),
             Text(user.email, style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),),
          ],
        ),
      ),
    );
  }
}
