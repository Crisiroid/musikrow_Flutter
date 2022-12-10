// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:musikrow/Screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestPremission();
  }

  void requestPremission() {
    Permission.storage.request();
    print("Access");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MusicROW',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 50, 4, 71),
      ),
      home: AnimatedSplashScreen(
        backgroundColor: Color.fromARGB(255, 50, 4, 71),
        splash: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: Text(
            "MusicRow",
            style: TextStyle(
                fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white),
          )),
        ),
        nextScreen: homeScreen(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
        duration: 2000,
      ),
    );
  }
}
