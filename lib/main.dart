import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dokta/screens/locate.dart';
import 'package:flutter/material.dart';
import './services/utils.dart';
import './screens/home.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dokta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Utils.buildMaterialColor(const Color(0xff5d40a2)),
      ),
      home: AnimatedSplashScreen(
          duration: 2000,
          splash: 'assets/dokta_logo.png',
          splashIconSize: 140,
          nextScreen: const MyHomePage(title: 'Dokta'),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white),
      routes: {'/locate': (context) => Locate()},
    );
  }
}
