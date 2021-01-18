import 'package:Raddi/Pages/Landing/landing_page.dart';
import 'package:Raddi/Route/transition.dart';
import 'package:Raddi/components/numric_pad.dart';
import 'package:Raddi/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home.dart';

class VerifyPhone extends StatefulWidget {
  final String phoneNumber;

  VerifyPhone({@required this.phoneNumber});

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  String code;
  bool isCodeSent = false;
  String verificationCode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    code = "";
    verificationCode = "";
    sendCode();
  }

  sendCode() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget.phoneNumber}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        UserCredential userCredential =
            await auth.signInWithCredential(credential);
        await Navigator.push(
          context,
          EnterExitRoute(
            exitPage: widget,
            enterPage: LandingPage(
              user: userCredential.user,
            ),
          ),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        // Handle other errors
      },
      codeSent: (String verificationId, int resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        // String smsCode = 'xxxx';

        setState(() {
          verificationCode = verificationId;
          isCodeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
//AutoResolution timeout
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Verify phone",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        textTheme: Theme.of(context).textTheme,
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: isCodeSent
                        ? Text(
                            "Code is sent to " + widget.phoneNumber,
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFF818181),
                            ),
                          )
                        : LinearProgressIndicator(),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        code.length > 0
                            ? buildCodeNumberBox(
                                code.substring(0, 1),
                                Colors.white,
                                kPrimaryColor,
                              )
                            : buildCodeNumberBox(
                                "",
                                Color(0xFF1F1F1F),
                                Color(0xFFF6F5FA),
                              ),
                        code.length > 1
                            ? buildCodeNumberBox(code.substring(1, 2),
                                Colors.white, kPrimaryColor)
                            : buildCodeNumberBox(
                                "",
                                Color(0xFF1F1F1F),
                                Color(0xFFF6F5FA),
                              ),
                        code.length > 2
                            ? buildCodeNumberBox(
                                code.substring(2, 3),
                                Colors.white,
                                kPrimaryColor,
                              )
                            : buildCodeNumberBox(
                                "",
                                Color(0xFF1F1F1F),
                                Color(0xFFF6F5FA),
                              ),
                        code.length > 3
                            ? buildCodeNumberBox(code.substring(3, 4),
                                Colors.white, kPrimaryColor)
                            : buildCodeNumberBox(
                                "",
                                Color(0xFF1F1F1F),
                                Color(0xFFF6F5FA),
                              ),
                        code.length > 4
                            ? buildCodeNumberBox(code.substring(4, 5),
                                Colors.white, kPrimaryColor)
                            : buildCodeNumberBox(
                                "",
                                Color(0xFF1F1F1F),
                                Color(0xFFF6F5FA),
                              ),
                        code.length > 5
                            ? buildCodeNumberBox(code.substring(5, 6),
                                Colors.white, kPrimaryColor)
                            : buildCodeNumberBox(
                                "",
                                Color(0xFF1F1F1F),
                                Color(0xFFF6F5FA),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Didn't recieve code? ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF818181),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Resend the code to the user");
                          },
                          child: Text(
                            "Request again",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.13,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        print("Verify and Create Account");
                        // Create a PhoneAuthCredential with the code
                        PhoneAuthCredential phoneAuthCredential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationCode,
                                smsCode: code);

                        // Sign the user in (or link) with the credential
                        UserCredential userCredential = await auth
                            .signInWithCredential(phoneAuthCredential);
                        await Navigator.push(
                          context,
                          EnterExitRoute(
                            exitPage: widget,
                            enterPage: LandingPage(
                              user: userCredential.user,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withAlpha(254),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Verify and Create Account",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          NumericPad(
            onNumberSelected: (value) {
              print(value);
              setState(() {
                if (value != -1) {
                  if (code.length < 6) {
                    code = code + value.toString();
                  }
                } else {
                  code = code.substring(0, code.length - 1);
                }
                print(code);
              });
            },
          ),
        ],
      )),
    );
  }

  Widget buildCodeNumberBox(
      String codeNumber, Color textColor, Color boxColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 45,
        height: 45,
        child: Container(
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75))
            ],
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
