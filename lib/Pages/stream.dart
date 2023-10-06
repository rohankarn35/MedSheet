import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_sheet/Login%20Screen/LoginScreen.dart';
import 'package:med_sheet/Pages/homescreen.dart';
import 'package:med_sheet/Pages/navigation.dart';

class StreamWidget extends StatelessWidget {
  const StreamWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return Text("An error occurred");
        }
       if (snapshot.connectionState == ConnectionState.active) {
  if (snapshot.data == null) {
    print("User is not authenticated. Navigating to LoginScreen.");
    return LoginScreen();
  } else {
    try {
    print("User is authenticated. Navigating to Navigation screen.");

    return Navigation(user: FirebaseAuth.instance.currentUser);
      
    } catch (e) {
      print("Error ${e}");
      
    }
  }
}

        // Return a fallback widget or null if needed.
        return CircularProgressIndicator(); // You can use a different widget here if needed.
      },
    );
  }
}
