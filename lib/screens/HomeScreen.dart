import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:placement_cell/UserMessages.dart';
import 'package:placement_cell/screens/AllMessages.dart';
import 'package:placement_cell/screens/DashBoard.dart';
import 'package:placement_cell/screens/IntroPage.dart';
import 'package:placement_cell/screens/OfficialProfileScreen.dart';
import 'package:provider/provider.dart';
import '../screens/ProfilePage.dart';
import '../screens/SearchPage.dart';
import 'dart:developer';
import 'package:placement_cell/userdata.dart' as admin;
import '../widgets/full_userdata.dart' as users;
import '../screens/UserSearchPage.dart';

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
        .where("uid", isEqualTo: admin.User.userid)
        .get()
        .then((value) {
      var z = value.docs[0].data();
      admin.User.setdata(z);
    }).then((value) {
      log(admin.User.mode.toString() + " mode at home page");
      if (admin.User.mode == admin.Mode.Student &&
          admin.User.batch.toString().isEmpty)
        givealert();
      else if (admin.User.mode != admin.Mode.Student &&
          admin.User.company.toString().isEmpty) givealert();
    });
    //DO THIS PART ON SEARCH PAGE OR MESSGAGE PAGE
    // if (admin.User.mode == admin.Mode.Student) {
    //   await FirebaseFirestore.instance
    //       .collection("officials")
    //       .get()
    //       .then((val) {
    //     var z = val.docs;
    //     List temp = [];
    //     z.forEach((element) {
    //       if (element.data().containsKey("company")) temp.add(element.data());
    //     });
    //     users.setl(temp);
    //     users.setpartialdata(temp);
    //     log("running z.docs");
    //   });
    //   // await FirebaseFirestore.instance
    //   //     .collection("users")
    //   //     .where("uid", isEqualTo: admin.User.userid)
    //   //     .get()
    //   //     .then((value) {
    //   //   var z = value.docs[0].data();
    //   //   admin.User.setdata(z);
    //   //   if (admin.User.batch == null) givealert();
    //   // });
    // } else {
    //   log("offcial mode ");
    //   await FirebaseFirestore.instance.collection("users").get().then((val) {
    //     var z = val.docs;
    //     List temp = [];
    //     z.forEach((element) {
    //       if ((element.data() as Map<String, dynamic>).containsKey("batch"))
    //         temp.add(element.data());
    //     });
    //     users.setl(temp);
    //     users.setpartialdata(temp);
    //     log("running z.docs");
    //   });
    //   // await FirebaseFirestore.instance
    //   //     .collection("officials")
    //   //     .where("uid", isEqualTo: admin.User.userid)
    //   //     .get()
    //   //     .then((value) {
    //   //   var z = value.docs[0].data();
    //   //   admin.User.setdata(z);
    //   //   log("setting data called on homescreen");
    //   //   if (admin.User.company == null) givealert();
    //   // });
    // }
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
                      if (admin.User.mode == admin.Mode.Student) {
                        if (value == 4 && admin.User.batch == null) {
                          givealert();
                          return;
                        }
                      } else {
                        if (value == 4 && admin.User.company == null) {
                          givealert();
                          return;
                        }
                      }
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
                            ? (admin.User.mode == admin.Mode.Student)
                                ? UserSearchPage()
                                : SearchPage()
                            : value == 3
                                ? AllMessages()
                                : (admin.User.mode == admin.Mode.Student)
                                    ? ProfilePage("")
                                    : OfficialProfileScreen());
          else
            return Center(child: CircularProgressIndicator());
        });
  }
}
