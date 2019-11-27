import 'package:flutter/material.dart';

class AskkitThemes {
  static lightTheme() {
    return ThemeData(
        primaryColor: Colors.blueAccent,
        primaryColorDark: Color(0xFF1976D2),
        primaryColorLight: Color(0xFF448aff),
        dialogBackgroundColor: Color(0xFFe3f2fd),
        backgroundColor: Color(0xFFEBEBEB),
        canvasColor: Colors.white,
        buttonColor: Colors.blueAccent,
        accentColor: Color(0xFFE64A19),
        dividerColor: Color(0xFFBDBDBD),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.blueAccent),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 1.0)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
      ),
        textTheme: TextTheme(
          title: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          subtitle: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          headline: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.white, height: 1.25),
          subhead: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
          body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
          body2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),

        )
    );
  }
}