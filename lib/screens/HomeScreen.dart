import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:placement_cell/screens/DashBoard.dart';
import 'package:placement_cell/screens/IntroPage.dart';
import '../screens/ProfilePage.dart';
import '../screens/SearchPage.dart';
import 'dart:developer';
import 'package:placement_cell/userdata.dart' as admin;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int value = 0;
  final _user = admin.User();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _user.fetchdata(),
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
                          label: 'Profile', icon: Icon(Icons.person))
                    ]),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).primaryColor,
                  title: Text('JMI PLACEMENT CELL'),
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
                            : ProfilePage(""));
          else
            return Center(child: CircularProgressIndicator());
        });
  }
}
