import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi{
  // static final _googleSignIn = GoogleSignIn();
  // static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  // static Future logout() => _googleSignIn.disconnect();
  static Future login() async{

    GoogleSignInAccount? googleuser  =await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleauth = await googleuser?.authentication;
    AuthCredential credential =  GoogleAuthProvider.credential(
      idToken: googleauth?.idToken,
      accessToken: googleauth?.accessToken,
     );

      UserCredential user =  await   FirebaseAuth.instance.signInWithCredential(credential);
      print(user.user?.displayName);
      // print(user.user.)
  }
  
}