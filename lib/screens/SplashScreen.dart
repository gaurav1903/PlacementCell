import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushNamed('authscreen');
    });
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
  }
}
