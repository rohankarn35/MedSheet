import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:med_sheet/Pages/reports.dart';
import 'package:med_sheet/Pages/userinfo.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User? user = widget.user;
  // int selectedindex = 1;

  // List<Widget> _screens =  const [
  //   filepicker(),
  // // HomeScreen(user: user);
  //   reports(),

  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(title: Text("Home Screen"),

        // centerTitle: true,
        // backgroundColor: Colors.deepPurpleAccent,
        // ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Colors.red,
          child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              // color: Colors.amber,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                color: Colors.deepPurpleAccent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 60),
                    child: Text(
                      "Welcome Back,\n ${user?.displayName}",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  // Image.network("https://thumbs.dreamstime.com/b/unknown-male-avatar-profile-image-businessman-vector-unknown-male-avatar-profile-image-businessman-vector-profile-179373829.jpg",height: 100,width: 100,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserInfos(imageUrl: user!.photoURL, username: user!.displayName, useremail: user!.email, noreports: user!.uid)));

                      },
                      child: Hero(
                        tag: 'profileimg',
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.deepPurpleAccent,
                          backgroundImage: user?.photoURL == null
                              ? NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/512/21/21104.png")
                              : NetworkImage(
                                  "${user?.photoURL}",
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              "Heart Beat Data",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 350,
                width: 500,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: const Color(0xff37434d),
                        width: 1,
                      ),
                    ),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 6,
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 3),
                          FlSpot(1, 1),
                          FlSpot(2, 4),
                          FlSpot(3, 2),
                          FlSpot(4, 5),
                          FlSpot(5, 1),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ], // Remove the extra square bracket here
                  ),
                ),
              ),
            ),
          ]),
        ),
        // bottomNavigationBar: CurvedNavigationBar(
        //   animationDuration: Duration(milliseconds: 300),
        //   onTap: (index) {

        //     setState(() {
        //        selectedindex = index;
        //     });

        //   },
        //   index: selectedindex,
        //  color: Colors.red,
        //  buttonBackgroundColor: Colors.white,
        //   backgroundColor: Colors.white,
        //   items: [
        //   Icon(Icons.file_download_rounded),
        //   Icon(Icons.home),

        //   Icon(Icons.favorite)
        // ]),
      ),
    );
  }
}
