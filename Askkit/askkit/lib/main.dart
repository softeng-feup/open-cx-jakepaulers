import 'package:askkit/View/Theme.dart';
import 'package:flutter/material.dart';
import 'Controller/FirebaseController.dart';
import 'View/Pages/LogInPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AskKit',
      theme: AskkitThemes.lightTheme(),
      home: LogInPage(FirebaseController()),
    );
  }
}
