import 'dart:developer';

import 'package:Raddi/Pages/Landing/landing_page.dart';
import 'package:Raddi/Route/transition.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Raddi/Pages/Signup/components/background.dart';
import 'package:Raddi/Pages/Signup/components/or_divider.dart';
import 'package:Raddi/Pages/Signup/components/social_icon.dart';
import 'package:Raddi/components/already_have_an_account_acheck.dart';
import 'package:Raddi/components/rounded_button.dart';
import 'package:Raddi/components/rounded_input_field.dart';
import 'package:Raddi/components/rounded_password_field.dart';
import 'package:Raddi/Pages/Login/login_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Raddi/home.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email;
  String _password;

// Future<T> saveContact(){
//  if (_firstname.isNotEmpty &&
//         _lastname.isNotEmpty &&
//         _phone.isNotEmpty &&
//         _email.isNotEmpty ) {

// //           Firestore.instance.runTransaction((transaction) async{
// // DocumentSnapshot freshSnap = await transaction.get(document.reference);
// // await transaction.update(freshSnap.reference,{
// //   "votes"
// // });
//           userRef
//       Contact contact = Contact(this._firstname, this._lastname, this._phone,
//           this._email, this._address, this._photoUrl);
//       await _databaseReference.push().set(contact.toJson());
//       navigateToLastScreen(context);
// }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
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
                text: "SIGNUP",
                press: () async {
                  log('About to create User');
                  try {
                    UserCredential userCredential =
                        await auth.createUserWithEmailAndPassword(
                            email: _email, password: _password);
                    log(' User created');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                      // showToast(
                      //     'The password provided is too weak.', Colors.red);
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      // showToast('The account already exists for that email.',
                      //     Colors.red);
                    }
                  } catch (e) {
                    print(e);
                  }
                }

                // async {//for image picker
                //   FilePickerResult result = await FilePicker.platform.pickFiles();
                //   if (result != null) {
                //     PlatformFile file = result.files.first;

                //     print(file.name);
                //     print(file.bytes);
                //     print(file.size);
                //     print(file.extension);
                //     print(file.path);
                //   } else {
                //     print('User canceled the picker');
                //   }
                // },
                ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
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
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // void showToast(message, Color color) {
  //   Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 2,
  //       backgroundColor: color,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

  void getAuthStatus() {
    auth.authStateChanges().listen((User user) async {
      if (user == null) {
        print('User is currently signed out!');

        Navigator.push(
          context,
          EnterExitRoute(
            exitPage: widget,
            enterPage: LandingPage(
              user: user,
            ),
          ),
        );
      } else {
        print('User is signed in!');
      }
    });
  }
}
