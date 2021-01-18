import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../constants.dart';

class SignupPage extends StatefulWidget {
  SignupPage({this.onSuccessfulSignUp, this.onPressed, this.image});

  final Function onSuccessfulSignUp, onPressed;
  final Widget image;
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState> _signupformKey;

  String _errorEmailText;
  String _errorPasswordText;

  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _signupformKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showSignUpSpinner = false;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSignUpSpinner,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.image,
                //Sign-Up Form Section
                Container(
                  child: Form(
                    key: _signupformKey,
                    child: Column(
                      children: [
                        //Sign-Up Email Field
                        TextFormField(
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
                        //Sign-Up Password Field
                        TextFormField(
                          obscureText: _passwordVisible,
                          controller: _passwordController,
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
                              return 'Please Enter Password with length greater than 6';
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
                        SizedBox(
                          height: 20,
                        ),
                        //Sign-Up Conform Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _passwordVisible,
                          // autofocus: false,
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Please Enter Your Password Again';
                            }
                            if (!(value
                                    .trim()
                                    .compareTo(_passwordController.text) ==
                                0)) {
                              return "Password Doesn't Match";
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
                            hintText: 'confirm password',
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
                //Sign-Up Button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    elevation: 5.0,
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      onPressed: () async {
                        // log(MediaQuery.of(context)
                        //     .viewInsets
                        //     .bottom
                        //     .toString());
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        if (_signupformKey.currentState.validate()) {
                          setState(() {
                            showSignUpSpinner = true;
                          });
                          try {
                            // UserCredential userCredential =
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                            _emailController.clear();
                            _passwordController.clear();
                            _confirmPasswordController.clear();
                            // log(' User created');
                            widget.onSuccessfulSignUp.call();
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              // log('The password provided is too weak.');
                              setState(() {
                                showSignUpSpinner = false;
                                _errorPasswordText =
                                    'The password provided is too weak.';
                              });
                              // showToast(
                              //     'The password provided is too weak.', Colors.red);
                            } else if (e.code == 'email-already-in-use') {
                              log('The account already exists for that email.');
                              setState(() {
                                showSignUpSpinner = false;
                                _errorEmailText =
                                    'The account already exists for that email.';
                              });
                              // showToast('The account already exists for that email.',
                              //     Colors.red);
                            }
                          } catch (e) {
                            // print(e);
                          }
                        }
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an acccount?',
                    ),
                    TextButton(
                      onLongPress: () {
                        log('Long press');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Login'),
                              content: Text(
                                  'if you have already registered please consider login'),
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
                      child: Text('Login'),
                    )
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
