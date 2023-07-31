import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Components/rounded_button.dart';
import 'package:flash_chat/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  @override
  static const String id = 'login';
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  bool ShowSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email= '';
  String password='';
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlurryModalProgressHUD(
        inAsyncCall: ShowSpinner,
        blurEffectIntensity: 4,
        progressIndicator: SpinKitFadingCircle(
          color: Colors.blueAccent,
          size: 90.0,
        ),
        dismissible: false,
        opacity: 0.4,
        color: Colors.black87,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email'
                )
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Log In',colour:Colors.lightBlueAccent ,onpressed: () async {
                setState(() {
                  ShowSpinner = true;
                });
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (user != null) {

                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                  setState(() {
                    ShowSpinner = false;
                  });
                }
                catch(e){
                  print(e);
                }

              },),

            ],
          ),
        ),
      ),
    );
  }
}
