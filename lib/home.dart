import 'dart:developer';

import 'package:Raddi/Pages/Landing/landing_page.dart';
import 'package:Raddi/Pages/Welcome/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final db = FirebaseFirestore.instance;
//TODO: Create user json with property account type: mail, google, facebook, name , address{streetname, room number}, username, active{datetimeloggeed in, duraition},
final usersRef = db.collection('users');

//TODO: Fixed Slots morning:, midday:, midnight
final slotsRef = db.collection('slots');

//TODO: bestprice, other vendor price if any
final priceRef = db.collection('price');

//TODO: region availablility
final regionRef = db.collection('region');

//TODO: How to integrate map

final GoogleSignIn googleSignIn = GoogleSignIn();
final DateTime timestamp = DateTime.now();

//  auth.User user = auth.FirebaseAuth.instance.authStateChanges()
FirebaseAuth auth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget loadingWidget = Container(
    color: Colors.amber[100],
    // child: ,
  );

  bool showSpinner = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log('In Home Init');
    getCurrentUser();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        log(visible.toString());
      },
    );
  }

  getCurrentUser() {
    User user = auth.currentUser;
    if (user != null) {
      //User is signed in
      log(user.photoURL ?? 'null');
      setState(() {
        loadingWidget = LandingPage(
          user: user,
        );
        showSpinner = false;
      });
    } else {
      //No user is signed in
      setState(() {
        loadingWidget = Welcome();
        showSpinner = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    log('In Home dispose`');
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: loadingWidget,
    );
  }
}
