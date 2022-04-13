import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_store/homepage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'validator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key, @required this.user, @required this.index})
      : super(key: key);
  final UserModel user;
  final int index;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _acceptedTNC = false, _isLoading = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
    if (_validate()) {
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
    //StorageReference reference = _storage.ref().child("assets/images/");
    //StorageUploadTask uploadTask = reference.putFile(_file);
    //uploadTask.onComplete.then((snapshot) async {
    //  print(await snapshot.ref.getDownloadURL());
    //});
    // return;
    /*final user = UserModel(
        username: _username.text,
        mobile: _mobile.text,
        address: _address.text,
        password: _password.text,
        email: _email.text,
        image: _file != null ? base64.encode(_file.readAsBytesSync()) : null,
        dob: _dob.text);
    CollectionReference collectionReference =
        Firestore.instance.collection('data_store');
    await collectionReference.add(user.toJson());*/
  }

  //update value in firebase
  _updateData() async {
    print(widget.user.toJson());
    final user = widget.user.copyWith(
      email: _email.text,
      username: _username.text,
      mobile: _mobile.text,
      dob: _dob.text,
      address: _address.text,
      password: _password.text,
      image: _file != null ? base64.encode(_file.readAsBytesSync()) : null,
    );
    print(user.toJson());
    CollectionReference collectionReference =
        Firestore.instance.collection('data_store');
    QuerySnapshot querySnapshot = await collectionReference.getDocuments();
    querySnapshot.documents[widget.index].reference.updateData(user.toJson());
    print(_file);
    Navigator.pop(context);
  }

  @override
  void initState() {
    _username = TextEditingController(text: widget.user?.username);
    _mobile = TextEditingController(text: widget.user?.mobile);
    _address = TextEditingController(text: widget.user?.address);
    _password = TextEditingController(text: widget.user?.password);
    _email = TextEditingController(text: widget.user?.email);
    _dob = TextEditingController(text: widget.user?.dob);
    // if (widget.user.image != null) {
    //   _file = File.fromRawPath(base64.decode(widget.user.image));
    // }
    // else{
    //  // print("Image Not Found");
    // }
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
                  labelText: 'Username',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _mobile,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mobile',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
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

  bool _validate() {
    if (_username.text.isEmpty ||
        _email.text.isEmpty ||
        _mobile.text.isEmpty ||
        _password.text.isEmpty) {
      showMsg('All fields are required');
      return false;
    }

    if (!Validator.validateTextWithSpace(_username.text)) {
      showMsg('Name must not contain any special character');
      // _fullNameFN.requestFocus();
      return false;
    }

    if (!Validator.validateMobile(_mobile.text)) {
      showMsg('Invalid mobile');
      // _mobileFN.requestFocus();
      return false;
    }

    if (!Validator.validateEmail(_email.text)) {
      showMsg('Invalid E-mail');
      //_emailFN.requestFocus();
      return false;
    }

    if (_password.text.isEmpty) {
      showMsg('Please enter password');
      //_passwordFN.requestFocus();
      return false;
    }

    if (!Validator.validatePassword(_password.text)) {
      showMsg('Password must be in between 8 - 15 char');
      // _passwordFN.requestFocus();
      return false;
    }

    return true;
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
