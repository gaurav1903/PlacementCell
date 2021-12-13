import 'package:flutter/material.dart';
import 'package:placement_cell/screens/AuthScreen.dart';
import 'package:placement_cell/screens/HomeScreen.dart';
import 'package:placement_cell/screens/SplashScreen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: Color(0xFF418C66), canvasColor: Colors.white),
        routes: {
          'homepage': (context) => HomePage(),
          'authscreen': (context) => AuthScreen()
        },
        home: SplashScreen());
  }
}
