import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  static const String id = 'register';
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email='';
  String password ='';
  bool ShowSpinner = false;
  final _auth= FirebaseAuth.instance;
  @override
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
                  email=value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',

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
                 password=value;
                },
                decoration: kTextFieldDecoration,
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Register',colour:Colors.blueAccent ,onpressed: () async{
                setState(() {
                  ShowSpinner = true;
                });

                try{

                  final newuser =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  if(newuser!=null){
                    Navigator.pushNamed(context, LoginScreen.id);
                  }
                  ShowSpinner =false;
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
