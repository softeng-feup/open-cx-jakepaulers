import 'package:flutter/material.dart';

class AskkitThemes {
  static lightTheme() {
    return ThemeData(
      primaryColor: Colors.blueAccent,
      backgroundColor: Color.fromARGB(255, 235, 235, 235),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 1.0)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
      ),
        textTheme: TextTheme(
          title: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          subtitle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        )
    );
  }
}