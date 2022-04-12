import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_store/homepage.dart';
import 'package:firebase_cloud_store/signup_page.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key, @required this.user, @required this.index})
      : super(key: key);
  final UserModel user;
  final int index;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  deleteData() async {
    CollectionReference collectionReference =
        Firestore.instance.collection('data_store');
    QuerySnapshot querySnapshot = await collectionReference.getDocuments();
    querySnapshot.documents[widget.index].reference.delete();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SignUpPage(
              index: widget.index,
              user: widget.user,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Information"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          if (widget.user.image != null)
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.memory(
                    base64Decode(widget.user.image),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )),
            ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Text(
                "Name",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text("-", style: TextStyle(fontSize: 16)),
              const SizedBox(
                width: 20,
              ),
              Text(widget.user.username, style: const TextStyle(fontSize: 16))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Text(
                "Email",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text("-", style: TextStyle(fontSize: 16)),
              const SizedBox(
                width: 20,
              ),
              Text(widget.user.email, style: const TextStyle(fontSize: 16))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Text(
                "Mobile",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text("-", style: TextStyle(fontSize: 16)),
              const SizedBox(
                width: 20,
              ),
              Text(widget.user.mobile, style: const TextStyle(fontSize: 16))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Text(
                "DOB",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text("-", style: TextStyle(fontSize: 16)),
              const SizedBox(
                width: 20,
              ),
              Text(widget.user.dob, style: const TextStyle(fontSize: 16))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 40,
            color: Colors.deepPurpleAccent,
            child: TextButton(
              onPressed: deleteData,
              child: const Text(
                "Delete My A/C",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SignUpPage(user: widget.user, index: widget.index)));
              },
              child: const Text("Edit")),
        ],
      ),
    );
  }
}
