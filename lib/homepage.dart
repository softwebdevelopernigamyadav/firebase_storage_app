import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_store/account_page.dart';
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
                final now = DateTime.now();
                final dob = DateTime.tryParse(data.dob) ?? now;
                final age = DateTime.now().year - dob.year;
                final thisYearsDOB = DateTime(now.year, dob.month, dob.day);
                final nextYearsDOB = DateTime(now.year + 1, dob.month, dob.day);
                return InkWell(
                  onTap: () {
                    if (thisYearsDOB.isAfter(now)) {
                      print("${thisYearsDOB.difference(now).inDays} days left");
                    } else {
                      print("${nextYearsDOB.difference(now).inDays} days left");
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AccountPage(
                              user: data,
                              index: index,
                            )));
                    // print(thisYearsDOB);
                    // print(nextYearsDOB);
                    // if (now.isBefore(thisYearsDOB)) {
                    //   print(thisYearsDOB.difference(now).inDays);
                    // } else {
                    //   print(nextYearsDOB.difference(now).inDays);
                    // }
                  },
                  child: ListTile(
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.email),
                        Text(data.dob),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Text(age.toString()),
                  ),
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

   UserModel copyWith(
      {String username,
      String email,
      String mobile,
      String address,
      String dob,
      String image,
      String password}) {
    return UserModel(
      username: username ?? this.username,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      password: password ?? this.password,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      image: image ?? this.image,
    );
  }
}
