import 'package:flutter/material.dart';
class RoundedButton extends StatelessWidget {
  RoundedButton({ required this.colour, required this.title, required this.onpressed });

  final Color colour;
  final String title;
  final Function onpressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Hero(
        tag: 'logo',
        child: Material(
          elevation: 5.0,
          color: colour ,
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: (){
              onpressed();
            },
            minWidth: 200.0,
            height:
            42.0,
            child: Text(
              title,
            ),
          ),
        ),
      ),
    );
  }
}