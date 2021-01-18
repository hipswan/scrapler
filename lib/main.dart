import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    log('In the material');
    return MaterialApp(
      title: '₹addi',
      // theme: ThemeData(fontFamily: "Nunito"),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.comfortaaTextTheme(),
        // rubikTextTheme()
        //confortaaTextTheme()
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<FirebaseApp>(
        future: _initialization,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('Oopsie ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Home();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
