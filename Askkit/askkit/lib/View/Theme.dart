import 'package:flutter/material.dart';

class AskkitThemes {
  static lightTheme() {
    return ThemeData(
        primaryColor: Colors.blueAccent,
        primaryColorDark: Color(0xFF1976D2),
        primaryColorLight: Color(0xFFe3f2fd),
        dialogBackgroundColor: Color(0xFFe3f2fd),
        backgroundColor: Color(0xFFEBEBEB),
        canvasColor: Colors.white,
        buttonColor: Colors.blueAccent,
        accentColor: Color(0xFFE64A19),
        dividerColor: Color(0xFFBDBDBD),
        highlightColor: Colors.blueAccent,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
            color: Colors.black
        ),

        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.blueAccent),
        ),
        textTheme: TextTheme(
          title: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          subtitle: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          headline: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.white),
          subhead: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
          body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
          body2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
        )
    );
  }

  static darkTheme() {
    return ThemeData(
        primaryColor: Colors.indigo,
        primaryColorDark: Colors.indigo.shade700,
        primaryColorLight: Colors.indigo.shade300,
        dialogBackgroundColor: Colors.indigo.shade300,
        backgroundColor: Colors.indigo.shade100,
        canvasColor: Colors.indigo.shade200,
        buttonColor: Colors.indigo,
        accentColor: Color(0xFFE64A19),
        dividerColor: Colors.indigo.shade300,
        highlightColor: Colors.indigo,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
            color: Colors.black
        ),

        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.indigo),
        ),
        textTheme: TextTheme(
          title: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold, color: Colors.indigo),
          subtitle: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold, color: Colors.indigo),
          headline: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.white),
          subhead: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
          body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black54),
          body2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black54),
        )
    );
  }
}