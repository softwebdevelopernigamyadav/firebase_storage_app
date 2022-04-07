import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_store/homepage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File _file;
  File _image;
  String _uploadedFileURL;

  final TextEditingController _username = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _dob = TextEditingController();

  void _addData() async {
    //StorageReference reference = _storage.ref().child("assets/images/");
    //StorageUploadTask uploadTask = reference.putFile(_file);
    //uploadTask.onComplete.then((snapshot) async {
    //  print(await snapshot.ref.getDownloadURL());
    //});
    // return;
    final user = UserModel(
        username: _username.text,
        mobile: _mobile.text,
        address: _address.text,
        password: _password.text,
        email: _email.text,
        image: _file != null ? base64.encode(_file.readAsBytesSync()) : null,
        dob: _dob.text);
    CollectionReference collectionReference =
        Firestore.instance.collection('data_store');
    await collectionReference.add(user.toJson());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomePage()));
  }

//upload image in firebase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Store"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    image: _file != null
                        ? DecorationImage(
                            image: FileImage(_file),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _username,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _mobile,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Mobile',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Address',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1997, 01, 13),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _dob.text = date.toString();
                  }
                },
                readOnly: true,
                controller: _dob,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'DOB',
                ),
              ),
              TextButton(onPressed: _addData, child: const Text("Submit")),
              //TextButton(onPressed: () {}, child: const Text("FetchData")),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _file = File(image.path);
      });
    }
  }
}
