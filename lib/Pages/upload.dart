import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:med_sheet/API/downloadfile.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';

import '../API/pdfviewer.dart';

class Upload extends StatefulWidget {
  final User? user;
  const Upload({super.key, required this.user});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  bool isUploading = false;
  double uploadProgress = 0.0;
  final FirebaseFirestore _firebasefirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfData = [];
  List<String> existingfile = [];

  Future<void> getExistingfile() async {
    final result =
        await _firebasefirestore.collection("${widget.user?.uid}").get();
    existingfile = result.docs.map((e) => e.data()["name"].toString()).toList();
    print("Existing Files ${existingfile}");
  }

  Future<void> uploadPdf(String filename, File file) async {
    final reference =
        FirebaseStorage.instance.ref().child("${widget.user?.uid}/$filename");
    final UploadTask = reference.putFile(
      file,
      SettableMetadata(
        customMetadata: {"percentage": "0"},
      ),
    );

    setState(() {
      isUploading = true;
    });
    UploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      reference.updateMetadata(SettableMetadata(
        customMetadata: {"percentage": (progress * 100).toStringAsFixed(2)},
      ));
      setState(() {
        uploadProgress = progress;
      });
    });
    await UploadTask.whenComplete(() {
      setState(() {
        isUploading = false;
        uploadProgress = 0.0;
      });
    });
  }

  void pickfile() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (pickedFile != null) {
        var uuid = Uuid();
        String filename = pickedFile.files[0].name;
        // filecheck(filename);

        print(filename);
        print("User name: ${widget.user?.email}");
        // print(existingfile);
        File file = File(pickedFile.files[0].path!);
        if (existingfile.contains(filename)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("File name already exist"),
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 500),
          ));
        } else {
          await uploadPdf(filename, file);
          final downloadLink = await FirebaseStorage.instance
              .ref()
              .child("${widget.user?.uid}/$filename")
              .getDownloadURL();
          await _firebasefirestore.collection("${widget.user?.uid}").add({
            "name": filename,
            "url": downloadLink,
            "id": uuid.v4(),
          });
        }

        // Wait for the upload to complete
        existingfile.add(filename);
        getPDF();
        print("Pdf upload Sucessfully");
      }
    } catch (e) {
      print("Exce ${e}");
    }
  }

  void getPDF() async {
    final result =
        await _firebasefirestore.collection("${widget.user?.uid}").get();
    pdfData = result.docs.map((e) => e.data()).toList();
    print(pdfData);
    setState(() {});
  }

  Future<void> deleteFile(String fileId) async {
    try {
      await FirebaseFirestore.instance
          .collection("${widget.user?.uid}")
          .where("id", isEqualTo: fileId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      print("PDF deleted from Firestore");
    } catch (e) {
      print("Error deleting PDF from Firestore: $e");
    }
  }

  Future<void> deletPDF(String filename) async {
    try {
      final reference =
          FirebaseStorage.instance.ref().child("${widget.user?.uid}/$filename");
      await reference.delete();

      print("Deleted from storage");
    } catch (e) {
      print("Error deleting: $e");
    }
  }

  void deletePDFs(String docid, String filename) async {
    await deleteFile(docid);
    await deletPDF(filename);
    getExistingfile();
    existingfile.remove(filename);

    print("Existing file after delete ${existingfile}");
    getPDF();
  }

//
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPDF();
    getExistingfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Reports"),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (isUploading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isUploading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Uploading ${uploadProgress.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 30),
                  itemCount: pdfData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, top: 5, left: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          
                                      await openFile(pdfData[index]['url'], pdfData[index]['name']);
                                        },
                                        child: Icon(
                                          Icons.download,
                                          size: 25,
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        print("Clicked");
                                        bool confirmDelete =
                                            await showDeleteConfirmationDialog(
                                                context);
                                        print(confirmDelete);
                                        if (confirmDelete) {
                                          deletePDFs(pdfData[index]['id'],
                                              pdfData[index]['name']);
                                        }
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        size: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PdfViewer(
                                          pdfUrl: pdfData[index]['url'])));
                                },
                                child: Image.network(
                                  "https://play-lh.googleusercontent.com/9XKD5S7rwQ6FiPXSyp9SzLXfIue88ntf9sJ9K250IuHTL7pmn2-ZB0sngAX4A2Bw4w",
                                  height: 120,
                                  width: 100,
                                ),
                              ),
                              Text(pdfData[index]['name'],
                                  style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        child: Icon(Icons.upload_file_rounded),
        onPressed: isUploading ? null : pickfile,
      ),
    );
  }
  Future<void> openFile(String url, String filename) async {
    final file = await DownloadFile(). downloadFile(url, filename);
    if (file == null) {
      print("File download failed");
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Download Failed"),
            backgroundColor: Colors.red
            ,
            duration: Duration(milliseconds: 300),
          ));
    
      return;
    }
    print("File path: ${file.path}");
    
    OpenFile.open(file.path);
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    bool confirmDelete = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this item?'),
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
