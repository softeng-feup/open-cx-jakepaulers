import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/Preferences.dart';
import 'package:askkit/View/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Controller/FirebaseController.dart';
import 'View/Pages/LogInPage.dart';

void main() async {
  SharedPreferences preferences = await Preferences.getPreferences();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  DatabaseController controller = FirebaseController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AskKit',
      theme: AskkitThemes.darkTheme(),
      home: LogInPage(controller),
    );
  }
}
