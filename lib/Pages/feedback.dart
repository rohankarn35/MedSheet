import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> getFeedback(String feedback) async {
    final collection = FirebaseFirestore.instance.collection("feedback");
    final user = FirebaseAuth.instance.currentUser;
    await collection.add({
      "feedback": feedback,
      "email": user?.email,
      "name": user?.displayName,
      "time": FieldValue.serverTimestamp(),
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 20),
              child: TextFormField(
                controller: _controller,
                maxLength: 500,
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Write your valuable feedback here",
                  border: OutlineInputBorder(
                    gapPadding: 10,
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 8,
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String feedbackText = _controller.text;
                  await getFeedback(feedbackText);
                  _controller.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Feedback submitted successfully"),
                    ),
                  );
                }
              },
              child: Text("Submit"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
