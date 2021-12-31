import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:placement_cell/UserMessages.dart';
import 'package:placement_cell/screens/AllMessages.dart';
import 'package:placement_cell/screens/DashBoard.dart';
import 'package:placement_cell/screens/IntroPage.dart';
import 'package:provider/provider.dart';
import '../screens/ProfilePage.dart';
import '../screens/SearchPage.dart';
import 'dart:developer';
import 'package:placement_cell/userdata.dart' as admin;
import '../widgets/full_userdata.dart' as users;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int value = 0;
  //TODO:: Problem here not setting data
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .where("role", isEqualTo: "Student")
            .get()
            .then((value) {
          var z = value.docs;
          log("running z.docs");
          admin.User.setdata(z.firstWhere((element) {
            return element.data()['uid'].toString() ==
                admin.User.userid.toString();
          }).data());
          users.setl(z.toList());
          users.setpartialdata(z.toList());
        }),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.done)
            return Scaffold(
                bottomNavigationBar: BottomNavigationBar(
                    onTap: (val) {
                      // log(val.toString());
                      setState(() {
                        value = val;
                      });
                    },
                    currentIndex: value,
                    backgroundColor: Colors.black,
                    unselectedItemColor: Colors.black,
                    selectedItemColor: Color(0xFF418C66),
                    items: [
                      BottomNavigationBarItem(
                          label: 'Home', icon: Icon(Icons.home)),
                      BottomNavigationBarItem(
                          label: 'Dashboard', icon: Icon(Icons.dashboard)),
                      BottomNavigationBarItem(
                          label: 'Search', icon: Icon(Icons.search)),
                      BottomNavigationBarItem(
                          label: 'Inbox', icon: Icon(Icons.chat)),
                      BottomNavigationBarItem(
                          label: 'Profile', icon: Icon(Icons.person)),
                    ]),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).primaryColor,
                  title:
                      value == 3 ? Text("Inbox") : Text('JMI PLACEMENT CELL'),
                  actions: [
                    IconButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Navigator.of(context).pushNamed('authscreen');
                          });
                        },
                        icon: Icon(Icons.logout))
                  ],
                ),
                body: value == 0
                    ? IntroPage()
                    : value == 1
                        ? DashBoard()
                        : value == 2
                            ? SearchPage()
                            : value == 3
                                ? AllMessages()
                                : ProfilePage(""));
          else
            return Center(child: CircularProgressIndicator());
        });
  }
}
