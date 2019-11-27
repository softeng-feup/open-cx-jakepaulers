import 'package:askkit/View/Controllers/Preferences.dart';
import 'package:askkit/View/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Controller/FirebaseController.dart';
import 'View/Pages/LogInPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xff1976D2)
    ));
    Preferences.getPreferences();
    return MaterialApp(
      title: 'AskKit',
      theme: AskkitThemes.lightTheme(),
      home: LogInPage(FirebaseController()),
    );
  }
}
