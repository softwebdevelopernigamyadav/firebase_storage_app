import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_store/homepage.dart';
import 'package:firebase_cloud_store/signup_page.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key, @required this.user, @required this.index}) : super(key: key);
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignUpPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Information"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
              //backgroundImage: Image.memory(data.image),
              ),
          Text(widget.user.username),
          Text(widget.user.email),
          Text(widget.user.mobile),
          Text(widget.user.dob),
          TextButton(
            onPressed: deleteData,
            child: const Text("Delete My A/C"),
          )
        ],
      ),
    );
  }
}
