import 'dart:developer';

import 'package:Raddi/Pages/Login/login_page.dart';
import 'package:Raddi/Pages/Signup/signup_page.dart';
import 'package:Raddi/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'Pages/Landing/landing_page.dart';
import 'Route/transition.dart';

class Registraion extends StatefulWidget {
  Registraion({Key key}) : super(key: key);

  @override
  _RegistraionState createState() => _RegistraionState();
}

class _RegistraionState extends State<Registraion> {
  bool isRegistered = true;

  Widget buildSvgScreenForLog(String path) {
    return Image(
      image: AssetImage('assets/images/login_bottom.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: isRegistered ? buildLoginPage() : buildSignUpPage(),
      child: isRegistered
          ? LoginPage(
              image: buildSvgScreenForLog('assets/images/login_bottom.png'),
              onPressed: () {
                setState(() {
                  isRegistered = false;
                });
              })
          : SignupPage(
              image: buildSvgScreenForLog('assets/images/login_bottom.png'),
              onSuccessfulSignUp: () {
                setState(() {
                  isRegistered = true;
                });
              },
              onPressed: () {
                setState(() {
                  isRegistered = true;
                });
              },
            ),
    );
  }
}
