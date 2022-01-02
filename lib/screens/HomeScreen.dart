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
  Future<dynamic> givealert() async {
    BuildContext _context = context;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text("ALERT : Incomplete Details",
                    style: TextStyle(color: Colors.red)),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          value = 4;
                        });
                        Navigator.of(_context, rootNavigator: true).pop();
                      },
                      child: Text("Complete details"))
                ]));
  }

  Future<void> func() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("role", isEqualTo: "Student")
        .get()
        .then((val) {
      var z = val.docs;
      log("running z.docs");
      admin.User.setdata(z.firstWhere((element) {
        return element.data()['uid'].toString() == admin.User.userid.toString();
      }).data());
      if (admin.User.batch == null) givealert();
      //TODO::CHECK HERE AND RAISE AN ERROR BOX THAT NAVIGATES TO PROFILE PAGE
      users.setl(z.toList());
      users.setpartialdata(z.toList());
    });
  }

  Future f = Future.value();
  @override
  void initState() {
    f = func();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: f,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.done)
            return Scaffold(
                bottomNavigationBar: BottomNavigationBar(
                    onTap: (val) {
                      // if (value == 4 && admin.User.batch == null) {//TODO::ON THESE LINES ,JUST TURNED OFF FOR TESTING
                      //   givealert();
                      //   return;
                      // }
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
