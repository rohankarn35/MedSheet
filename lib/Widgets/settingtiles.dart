import 'package:flutter/material.dart';

class tiles extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const tiles({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width-50,
                  decoration:  BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(10)
    
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20,),
                      Icon(icon),
                      SizedBox(width: 20,),
                      Text("${text}",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
    );
  }
}