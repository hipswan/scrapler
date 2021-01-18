import 'dart:developer';

import 'package:Raddi/Pages/Landing/landing_page.dart';
import 'package:Raddi/Route/transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Raddi/Pages/Login/components/background.dart';
import 'package:Raddi/Pages/Signup/signup_screen.dart';
import 'package:Raddi/components/already_have_an_account_acheck.dart';
import 'package:Raddi/components/rounded_button.dart';
import 'package:Raddi/components/rounded_input_field.dart';
import 'package:Raddi/components/rounded_password_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../home.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email;
  @override
  void initState() {
    super.initState();
    getAuthStatus();
  }

  String _password;
  void getAuthStatus() {
    auth.authStateChanges().listen((User user) {
      if (user != null) {
        print('User is signed in!');
        if (!user.emailVerified) {
          log('Email is not verified');
        } else {
          log('Email is  verified');
        }
      } else {
        print('User is currently signed out!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "LOGIN",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          SvgPicture.asset(
            "assets/icons/login.svg",
            height: size.height * 0.35,
          ),
          SizedBox(height: size.height * 0.03),
          RoundedInputField(
            hintText: "Your Email",
            onChanged: (value) {
              _email = value;
            },
          ),
          RoundedPasswordField(
            onChanged: (value) {
              _password = value;
            },
          ),
          RoundedButton(
            text: "LOGIN",
            press: () async {
              log(MediaQuery.of(context).viewInsets.bottom.toString());
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _email, password: _password);
                Navigator.push(
                  context,
                  EnterExitRoute(
                    exitPage: widget,
                    enterPage: LandingPage(
                      user: userCredential.user,
                    ),
                  ),
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                }
              }
              // Navigator.pop(context, "leleo");
            },
          ),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
