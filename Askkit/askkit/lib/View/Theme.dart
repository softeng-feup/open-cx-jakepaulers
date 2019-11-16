import 'package:flutter/material.dart';

class AskkitThemes {
  static lightTheme() {
    return ThemeData(
        primaryColor: Colors.blueAccent,
        primaryColorDark: Color(0xFF1976D2),
        primaryColorLight: Color(0xFF448aff),
        backgroundColor: Color(0xFFEBEBEB),
        canvasColor: Colors.white,
        buttonColor: Colors.blueAccent,
        accentColor: Color(0xFFFF9800),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.blueAccent),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 1.0)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
      ),
        textTheme: TextTheme(
          title: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          subtitle: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          button: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.white),
          headline: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.white, height: 1.25),
          subhead: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
          caption: TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal, color: Colors.white),

        )
    );
  }
}