import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:placement_cell/screens/AuthScreen.dart';
import 'package:placement_cell/screens/HomeScreen.dart';
import 'package:placement_cell/screens/SingleUser.dart';
import 'package:placement_cell/screens/SplashScreen.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../widgets/InputForm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: Color(0xFF418C66), canvasColor: Colors.white),
        routes: {
          'homepage': (context) => HomePage(),
          'authscreen': (context) => AuthScreen(),
          'inputform': (context) => InputForm(),
          'singleuser': (context) => SingleUser()
        },
        home: SplashScreen());
  }
}
