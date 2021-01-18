import 'dart:developer';

import 'package:Raddi/Pages/Login/login_screen.dart';
import 'package:Raddi/constants.dart';
import 'package:Raddi/registration.dart';
import 'package:Raddi/widgets/clip_shadow_path.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import 'package:Raddi/Route/transition.dart';

final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

auth.User user;

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  var _backgroundColor = Colors.white;
  bool isStarted = false;
  var _headingColor = Color(0xFFB40284A);

  double _headingTop = 100;

  double _loginWidth = 0;

  double _loginHeight = 0;

  double _loginOpacity = 1;

  double _loginYOffset = 0;

  double _loginXOffset = 0;

  double _registerYOffset = 0;

  double _registerHeight = 0;

  double windowWidth = 0;

  double windowHeight = 0;

  bool _keyboardVisible = false;

  @override
  // TODO: implement mounted
  bool get mounted => super.mounted;
  @override
  void initState() {
    super.initState();
    log("In Welcome Init  ${this.mounted}");
    // getCurrentUser();
  }

  // void getCurrentUser() async {
  //   auth.User _user = _firebaseAuth.currentUser;
  //   setState(() {
  //     user = _user;
  //   });
  // }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    log("In Welcome Did change Dependecies ${this.mounted}");

    //TODO: close keyboard when focus is on this widget.
  }

  @override
  void didUpdateWidget(covariant Welcome oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    log("In Welcome did update widget ${this.mounted}");
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    log("In welcome deactivate ${this.mounted}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    log("In Welcome  Dispose ${this.mounted}");
    isStarted = !isStarted;
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  //Title
                  Hero(
                    tag: 'title',
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "₹addi",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 35,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ".",
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 40,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Description
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      "We make buying and selling of scrape easy and profitable for you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _headingColor, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            //Illustration of Intent
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Center(
                child: Image.asset("assets/images/splash_bg.png"),
              ),
            ),
            //Bottom Clip Section with Get-Started button
            Stack(
              children: <Widget>[
                ClipShadowPath(
                  shadow: BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                  clipper: BottomWaveClipper(),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        //TODO:make it relative to phone
                        height: windowHeight * 0.16,

                        child: GestureDetector(
                          onTap: () async {
                            // Navigator.push(
                            //   context,
                            //   SlideLeftRoute(
                            //     page: LoginPage(),
                            //   ),
                            // );
                            setState(() {
                              isStarted = !isStarted;
                            });
                            // var gotback = await Navigator.push(
                            //   context,
                            //   EnterExitRoute(
                            //     exitPage: widget,
                            //     enterPage: Registraion(),
                            //   ),
                            // );
                            // log(gotback);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registraion()),
                            );
                          },
                          //Get-Started button layout design
                          //TODO: Create multiple border style
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Stack(children: [
                                  Container(
                                    margin: EdgeInsets.all(32),
                                    padding: EdgeInsets.all(20),
                                    width: (windowWidth - 32) / 3,
                                    decoration: BoxDecoration(
                                      color: Colors.pinkAccent,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey,
                                      //     blurRadius: 5.0,
                                      //     offset: !isStarted
                                      //         ? Offset(0, 5)
                                      //         : Offset.zero,
                                      //   ),
                                      // ],
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(32),
                                    padding: EdgeInsets.all(20),
                                    width: (windowWidth - 32) / 5,
                                    decoration: BoxDecoration(
                                      color: Colors.pinkAccent,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey,
                                      //     blurRadius: 5.0,
                                      //     offset: !isStarted
                                      //         ? Offset(0, 5)
                                      //         : Offset.zero,
                                      //   ),
                                      // ],
                                      // borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ]),
                              ),
                              // Container(
                              //   margin: EdgeInsets.all(32),
                              //   child: Positioned(
                              //     bottom: 10,
                              //     right: 5,
                              //     child: Container(
                              //         width: windowWidth * 0.3,
                              //         height: windowHeight * 0.5,
                              //         color: Colors.amberAccent),
                              //   ),
                              // ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.all(32),
                                  padding: EdgeInsets.all(20),
                                  width: (windowWidth - 32) / 3,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFB40284A),
                                    // borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: Container(
                              //     margin: EdgeInsets.all(32),
                              //     padding: EdgeInsets.all(20),
                              //     width: (windowWidth - 32) / 3,
                              //     decoration: BoxDecoration(
                              //       color: Colors.amber,
                              //       // borderRadius: BorderRadius.circular(50),
                              //     ),
                              //   ),
                              // ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Stack(children: [
                                  Container(
                                    margin: EdgeInsets.all(32),
                                    padding: EdgeInsets.all(20),
                                    width: (windowWidth - 32) / 3,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey,
                                      //     blurRadius: 5.0,
                                      //     offset: !isStarted
                                      //         ? Offset(0, 5)
                                      //         : Offset.zero,
                                      //   ),
                                      // ],
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(32),
                                    padding: EdgeInsets.all(20),
                                    width: (windowWidth - 32) / 6,
                                    decoration: BoxDecoration(
                                      color: Colors.pinkAccent,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey,
                                      //     blurRadius: 5.0,
                                      //     offset: !isStarted
                                      //         ? Offset(0, 5)
                                      //         : Offset.zero,
                                      //   ),
                                      // ],
                                      // borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ]),
                              ),
                              // Align(
                              //   alignment: Alignment.center,
                              //   child: Container(
                              //     margin: EdgeInsets.all(32),
                              //     padding: EdgeInsets.all(20),
                              //     width: 75,
                              //     decoration: BoxDecoration(
                              //       color: Color(0xFFB40284A),
                              //       // borderRadius: BorderRadius.circular(50),
                              //     ),
                              //     child: Center(
                              //       child: Icon(
                              //         Icons.arrow_forward_ios,
                              //         color: Colors.white,
                              //         size: 16,
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              //TODO: Add color to upper most layer to make thin borders
                              // Center(
                              //   child: Container(
                              //     margin: EdgeInsets.all(32),
                              //     padding: EdgeInsets.all(20),
                              //     // constraints: BoxConstraints(
                              //     //   maxHeight: windowHeight * 0.1,
                              //     // ),
                              //     width: windowWidth * 0.8,
                              //     height: windowHeight * 0.07,
                              //     decoration: BoxDecoration(
                              //       color: Colors.blueGrey,
                              //       borderRadius: BorderRadius.circular(50),
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         "Get Started",
                              //         style: TextStyle(
                              //           color: Colors.white,
                              //           fontSize: 16,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Draw a straight line from current point to the bottom left corner.
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    var firstControlPoint = Offset(size.width / 2, 45);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, 0.0, 0.0);
    // Draw a straight line from current point to the top right corner.

    // Draws a straight line from current point to the first point of the path.
    // In this case (0, 0), since that's where the paths start by default.
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
