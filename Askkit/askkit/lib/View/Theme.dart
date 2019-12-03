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
        iconTheme: IconThemeData(
            color: Colors.black
        ),

        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.blueAccent),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 1.0)),

        ),
        textTheme: TextTheme(
          title: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          subtitle: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          headline: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
          body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
          body2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
        )
    );
  }

  static darkTheme() {
    return ThemeData(
        primaryColor: Color(0xFF404040),
        primaryColorDark: Colors.lightBlue,
        primaryColorLight: Color(0xFF404040),
        backgroundColor: Color(0xFF121212),
        canvasColor: Color(0xFF303030),
        buttonColor: Colors.indigo.shade200,
        accentColor: Color(0xFFE35D34),
        dividerColor: Colors.indigo.shade400,
        highlightColor: Colors.indigo,
        iconTheme: IconThemeData(
            color: Color(0xDDFFFFFF)
        ),

        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.indigo.shade300),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Colors.indigo, width: 1.0)),
        ),
        textTheme: TextTheme(
          title: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold, color: Colors.indigo.shade200),
          subtitle: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold, color: Colors.indigo.shade200),
          headline: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.indigo.shade100),
          body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Color(0xDCFFFFFF)),
          body2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xCBFFFFFF)),
        )
    );
  }
}