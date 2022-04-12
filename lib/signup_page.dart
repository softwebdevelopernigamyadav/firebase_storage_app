import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_store/homepage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key, @required this.user, @required this.index})
      : super(key: key);
  final UserModel user;
  final int index;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File _file;

  TextEditingController _username;
  TextEditingController _mobile;
  TextEditingController _address;
  TextEditingController _password;
  TextEditingController _email;
  TextEditingController _dob;

  //add data  into  firebase
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

  //update value in firebase
  _updateData() async {
    print(widget.user.toJson());
    final user = widget.user.copyWith(
        // email: _email.text,
        // username: _username.text,
        mobile: _mobile.text,
        dob: _dob.text,
        address: _address.text,
        password: _password.text);
    print(user.toJson());
    /*CollectionReference collectionReference =
    Firestore.instance.collection('data_store');
    QuerySnapshot querySnapshot = await collectionReference.getDocuments();
    querySnapshot.documents[widget.index].reference.updateData(
        user.toJson());*/
  }

  @override
  void initState() {
    _username = TextEditingController(text: widget.user?.username);
    _mobile = TextEditingController(text: widget.user?.mobile);
    _address = TextEditingController(text: widget.user?.address);
    _password = TextEditingController(text: widget.user?.password);
    _email = TextEditingController(text: widget.user?.email);
    _dob = TextEditingController(text: widget.user?.dob);
    super.initState();
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
              if (widget.user != null && widget.index != null)
                TextButton(onPressed: _updateData, child: const Text("Update"))
              else
                TextButton(onPressed: _addData, child: const Text("Submit"))
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
