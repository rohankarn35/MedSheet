import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:med_sheet/Pages/applock.dart';
import 'package:med_sheet/Pages/feedback.dart';
import 'package:med_sheet/Pages/upload.dart';
import 'package:med_sheet/Widgets/settingtiles.dart';

import '../API/google_signin_api.dart';
import '../Login Screen/LoginScreen.dart';

class UserInfos extends StatefulWidget {
  final String? imageUrl;
  final String? username;
  final String? useremail;
  final String? noreports;
  const UserInfos(
      {super.key,
      required this.imageUrl,
      required this.username,
      required this.useremail,
      required this.noreports});

  @override
  State<UserInfos> createState() => _UserInfosState();
}

class _UserInfosState extends State<UserInfos> {
  final FirebaseFirestore _firebasefirestore = FirebaseFirestore.instance;
 bool _isBiometricSupported = false; 

  List<String> existingfile = [];

  Future<void> getExistingfile() async {
    final result =
        await _firebasefirestore.collection("${widget.noreports}").get();
    setState(() {
      existingfile =
          result.docs.map((e) => e.data()["name"].toString()).toList();
    });
    print("Existing Files ${existingfile.length}");
  }
 Future<bool?> isSupported() async{
   var auth = LocalAuthentication();
   if(await auth.isDeviceSupported()){
    return true;
   }
   else{
    return false;
   }
 }
  @override
  void initState() {
    super.initState();
    getExistingfile();
   isSupported().then((supported) {
      setState(() {
        _isBiometricSupported = supported ?? false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call getExistingfile() whenever dependencies change (e.g., user enters the page)
    getExistingfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 250,
                decoration: const BoxDecoration(
                    // border: Border.all(style: BorderStyle.solid,width: 2),
                    ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Hero(
                      tag: 'profileimg',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: widget.imageUrl == null
                            ? NetworkImage(
                                "https://cdn-icons-png.flaticon.com/512/21/21104.png")
                            : NetworkImage("${widget.imageUrl}"),
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "${widget.username}",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${widget.useremail}",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${existingfile.length}",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                  height: 25,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15)),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: (){
                         
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                           Upload(user: FirebaseAuth.instance.currentUser)
                          ));
                        },
                        child: Text('Reports Uploaded')),
                      Icon(Icons.navigate_next_outlined)
                    ],
                  )),
              const SizedBox(
                height: 40,
              ),
              tiles(
                icon: Icons.info_outline_rounded,
                text: "About",
                onTap: () {
                  
                },
              ),
              SizedBox(
                height: 20,
              ),
              
              Visibility(
            visible: _isBiometricSupported,
            child: tiles(
              icon: Icons.lock_open_rounded,
              text: "App Lock",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  MainPage()
                ));
              },
            ),
          ),
              Visibility(
                 visible: _isBiometricSupported,
                child: SizedBox(
                  height: 20,
                ),
              ),
              tiles(
                icon: Icons.feedback_rounded,
                text: "Feedback",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                    FeedBack()
                  ));
                },
              ),
              SizedBox(
                height: 20,
              ),
              tiles(
                icon: Icons.logout_rounded,
                text: "Logout",
                onTap: () async {
                  bool confirmDelete =
                      await showDeleteConfirmationDialog(context);
                  if (confirmDelete) {
                     Navigator.pop(context);
                  print("Clicked");
                   await GoogleSignIn().signOut();
                   FirebaseAuth.instance.signOut();
                  }
                 
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    bool confirmDelete = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to LogOut?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('No'),
              onPressed: () {
                setState(() {
                  confirmDelete = false;
                });
                Navigator.of(context).pop(false);
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  confirmDelete = true;
                });
                Navigator.of(context).pop(true); // Confirm delete
              },
            ),
          ],
        );
      },
    );

    return confirmDelete;
  }
}
