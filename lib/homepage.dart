import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Please wait..");
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                final data =
                    UserModel.fromJson(snapshot.data.documents[index].data);
                //print(DateTime.parse(data.dob));
                final differenceInDays = DateTime.now().difference(DateTime(1997, 01, 13)).inDays;
                print(DateTime.now().year-DateTime(1997, 01, 13).year);
                return ListTile(
                  leading: data.image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.memory(
                            base64.decode(data.image),
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Text(data.username[0].toUpperCase()),
                        ),
                  title: Text(data.username),
                  subtitle: Text(data.email),
                );
              },
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
            );
          }
        },
        stream: Firestore.instance.collection('data_store').snapshots(),
      ),
    );
  }
}

class UserModel {
  final String username;
  final String email;
  final String mobile;
  final String address;
  final String dob;
  final String image;
  final String password;

  UserModel(
      {this.username,
      this.email,
      this.mobile,
      this.address,
      this.dob,
      this.image,
      this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json["Username"],
      mobile: json["Mobile"],
      address: json["Address"],
      password: json["Password"],
      email: json["Email"],
      dob: json["DOB"],
      image: json["Image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Username": username,
      "Mobile": mobile,
      "Address": address,
      "Password": password,
      "Email": email,
      "DOB": dob,
      "Image": image,
    };
  }
}
