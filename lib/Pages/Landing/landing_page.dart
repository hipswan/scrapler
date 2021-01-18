import 'dart:developer';

import 'package:Raddi/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home.dart';

class LandingPage extends StatefulWidget {
  final User user;

  LandingPage({this.user});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isVerified = false;
  bool isMailSend = false;
  @override
  void initState() {
    super.initState();
    isVerified = widget.user.emailVerified;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.email}' ?? 'Nulla'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          User _currentUser =
              await widget.user.reload().then((_) => auth.currentUser);
          if (_currentUser.emailVerified) {
            log('verified');
            setState(() {
              isVerified = true;
            });
          }
        },
        displacement: 25,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Container(
            height: height * 0.99,
            margin: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                //user Avatar
                Container(
                  width: width * 0.99,
                  height: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: widget.user.photoURL != null
                          ? NetworkImage(widget.user.photoURL)
                          : AssetImage("assets/images/splash_bg.png"),
                    ),
                  ),
                ),

                !isVerified
                    ? //Email Verification Alert-Box
                    Container(
                        height: height * 0.2,
                        width: width * 0.99,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              !isMailSend ? Colors.red[50] : Colors.amber[50],
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: !isMailSend
                                ? Colors.red[400]
                                : Colors.amber[400],
                            style: BorderStyle.solid,
                            width: 10,
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                !isMailSend ? Colors.red[50] : Colors.amber[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: !isMailSend
                                  ? Colors.red[400]
                                  : Colors.amber[400],
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  isMailSend
                                      ? 'Verification Mail has been sent to ${widget.user.email}\nPlease swipe down after verification'
                                      : 'Please verify your e-mail for seemless experience',
                                  style: TextStyle(
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: !isMailSend
                                        ? Colors.red[300]
                                        : Colors.amber[600],
                                  ),
                                ),
                              ),
                              RaisedButton.icon(
                                elevation: 5,
                                shape: Border.all(),
                                onPressed: () async {
                                  if (!widget.user.emailVerified) {
                                    // await user.sendEmailVerification();

                                    widget.user
                                        .sendEmailVerification()
                                        .then((value) {
                                      log('Verification e-mail has been sent to ${widget.user.email}');
                                      setState(() {
                                        isMailSend = true;
                                      });
                                    });
                                  }
                                },
                                icon: Icon(Icons.verified),
                                label: Text(
                                    'Verified ${widget.user.emailVerified}'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Text(''),
                //Sign-Out Button
                FlatButton.icon(
                  onPressed: () async {
                    try {
                      await auth.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Home();
                          },
                        ),
                      );
                    } catch (e) {
                      log(e);
                    }
                  },
                  icon: Icon(Icons.exit_to_app),
                  label: Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
