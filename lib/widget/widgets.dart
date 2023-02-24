import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black87 , fontWeight: FontWeight.w400 , fontSize: 15),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFF01C7D2),
      width: 2,
    ),
  ),

  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFF01C7D2),
      width: 2,
    ),
  ),

  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFF01C7D2),
      width: 2,
    ),
  ),
);

void nextScreen(context, page){
  Navigator.push(context , MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page){
  Navigator.pushReplacement(context , MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context , color , message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 18,
      ),
    ),
    backgroundColor: color,
    duration: Duration(seconds: 2),
    action: SnackBarAction(
      label: "Ok",
      onPressed: (){},
      textColor: Colors.white,
    ),
  ));
}