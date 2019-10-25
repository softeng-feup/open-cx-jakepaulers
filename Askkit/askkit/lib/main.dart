import 'package:flutter/material.dart';
import 'View/Pages/ConferencePage.dart';
import 'View/Pages/LogInPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AskKit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LogInPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return LogInPage();
  }
}
