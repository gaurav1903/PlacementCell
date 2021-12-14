import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snap) {
          if (snap.hasData) {
            var t = Timer(Duration(seconds: 2), () {
              Navigator.of(context).pushNamed('homepage');
            });
          } else {
            var t = Timer(Duration(seconds: 2), () {
              Navigator.of(context).pushNamed('authscreen');
            });
          }
          return Container(
            color: Theme.of(context).canvasColor,
            child: Center(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).canvasColor,
                minRadius: 20,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/splash.jpg')),
              ),
            ),
          );
        });
  }
}
