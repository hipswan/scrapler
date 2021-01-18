import 'package:Raddi/Pages/Landing/landing_page.dart';
import 'package:Raddi/Pages/Signup/components/or_divider.dart';
import 'package:Raddi/Pages/Signup/components/social_icon.dart';
import 'package:Raddi/Route/transition.dart';
import 'package:Raddi/components/continue_with_phone.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.onPressed, this.image});
  final Function onPressed;
  final Widget image;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _loginformKey;

  String _errorEmailText;
  String _errorPasswordText;

  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _loginformKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    bool showLoginSpinner = false;
    // assert(debugCheckHasMaterial(context));
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showLoginSpinner,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.image,
                //Login Form
                Container(
                  child: Form(
                    key: _loginformKey,
                    child: Column(
                      children: [
                        //Login Email Text Field
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.left,
                          controller: _emailController,
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Please Enter Your Email';
                            }
                            if (!value.trim().contains(new RegExp(r'[.]')) ||
                                !value.trim().contains(new RegExp(r'[@]'))) {
                              return 'Please Enter Valid Email';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            errorText: _errorEmailText ?? '',
                            hintText: 'Enter Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        //Login Password Text Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _passwordVisible,
                          // autofocus: false,
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Please Enter Your Password';
                            }
                            if (!value.trim().contains(new RegExp(r'[0-9]'))) {
                              return 'Please Include Number';
                            }
                            //  if (!value.contains(new RegExp(r'[@&^*$#!_]'))) {
                            //   return 'Please Include Special Charater';
                            // }
                            if (!(value.trim().length >= 6)) {
                              return 'Please Enter Password with greater length';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            errorText: _errorPasswordText,
                            border: InputBorder.none,
                            hintText: 'password',
                            filled: true,
                            fillColor: Colors.grey,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 6.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Login Button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                  child: Material(
                    elevation: 5.0,
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      onPressed: () async {
                        //suppose to disable the kepad
                        // log(MediaQuery.of(context)
                        //     .viewInsets
                        //     .bottom
                        //     .toString());
                        // log(_emailController.text);
                        // log(_passwordController.text);
                        // to disable the kepad
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        if (_loginformKey.currentState.validate()) {
                          setState(() {
                            showLoginSpinner = true;
                          });
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                            _emailController.clear();
                            _passwordController.clear();
                            await Navigator.push(
                              context,
                              EnterExitRoute(
                                exitPage: widget,
                                enterPage: LandingPage(
                                  user: userCredential.user,
                                ),
                              ),
                            );
                            setState(() {
                              showLoginSpinner = false;
                            });
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              // log('No user found for that email.');
                              setState(() {
                                showLoginSpinner = false;
                                _errorEmailText =
                                    'No user found for that email.';
                              });
                            } else if (e.code == 'wrong-password') {
                              // log('Wrong password provided for that user.');
                              setState(() {
                                showLoginSpinner = false;
                                _errorPasswordText =
                                    'Wrong password provided for that user.';
                              });
                            }
                          } catch (e) {
                            // log(e);
                          }
                        }
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                //Login to Signup transition section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an acccount?",
                    ),
                    TextButton(
                      onLongPress: () {
                        // log('Long press');

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Sign Up'),
                              content: Text(
                                  'if you have not registered please proceed with sign up'),
                              actions: <Widget>[
                                FlatButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.arrow_back),
                                  label: Text('Back'),
                                )
                              ],
                            );
                          },
                        );
                      },
                      onPressed: widget.onPressed,
                      child: Text('Sign Up'),
                    )
                  ],
                ),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SocalIcon(
                      iconSrc: "assets/icons/facebook.svg",
                      press: () {},
                    ),
                    SocalIcon(
                      iconSrc: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                    SocalIcon(
                      iconSrc: "assets/icons/google-plus.svg",
                      press: () {
                        Navigator.push(
                          context,
                          EnterExitRoute(
                            exitPage: widget,
                            enterPage: ContinueWithPhone(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
