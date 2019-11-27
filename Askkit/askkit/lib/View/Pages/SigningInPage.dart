import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/AuthListener.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Pages/LogInPage.dart';
import 'package:askkit/View/Pages/TalksPage.dart';
import 'package:askkit/View/Widgets/TitleText.dart';
import 'package:flutter/material.dart';

abstract class SigningPage extends StatefulWidget {
  final DatabaseController _dbcontroller;

  SigningPage(this._dbcontroller);

  performSign(AuthListener listener);
}

class SigningInPage extends SigningPage {
  String password;
  String username;

  SigningInPage(DatabaseController dbcontroller, this.username, this.password) : super(dbcontroller);

  @override
  State<StatefulWidget> createState() => SigningPageState("Signing in...");

  @override
  performSign(AuthListener listener) => this._dbcontroller.signIn(username, password, listener);
}

class SigningUpPage extends SigningPage {
  String password;
  String username;
  String email;

  SigningUpPage(DatabaseController dbcontroller, this.email, this.username, this.password) : super(dbcontroller);

  @override
  State<StatefulWidget> createState() => SigningPageState("Signing up...");

  @override
  performSign(AuthListener listener) => this._dbcontroller.signUp(email, username, password, listener);
}

class SigningPageState extends State<SigningPage> implements AuthListener {
  SigningPageState(String text) {
    this.widgets = [
      Container(
          margin: EdgeInsets.only(bottom: 25.0),
          child: CircularProgressIndicator()
      ),
      _defaultText(text, upperTextSize)
    ];
  }

  List<Widget> widgets;

  static const double upperTextSize = 20.0;
  static const double lowerTextSize = 15.0;

  @override
  void initState() {
    super.initState();
    widget.performSign(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleText(text: "Askkit", margin: EdgeInsets.only(top: 25.0)),
            SubtitleText(text: "Ask away!", margin: EdgeInsets.only(bottom: 25.0)),
            Column (
                mainAxisAlignment: MainAxisAlignment.center,
                children: widgets
            )
          ],
        )
    );
  }

  Widget _defaultText(String text, double fontSize) => Center(
    child: Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize), textAlign: TextAlign.center)
    )
  );

  Widget _backButton(BuildContext context) =>
      FlatButton(
        onPressed: () { Navigator.pop(context); },
        child: Text("Back"),
      );

  Widget _toLoginButton(BuildContext context) =>
      FlatButton(
        onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInPage(widget._dbcontroller))); },
        child: Text("Back to login"),
      );

  Widget _toTalksButton(BuildContext context) =>
      FlatButton(
        onPressed: () { Navigator.pop(context); Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TalksPage(widget._dbcontroller))); },
        child: Text("Continue"),
      );

  @override
  void onSignInIncorrect() {
    setState(() {
      this.widgets = [ _defaultText("Login failed", upperTextSize), _defaultText("Username and password do not match.", lowerTextSize), _backButton(context) ];
    });
  }

  @override
  void onSignInSuccess(User user) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => TalksPage(widget._dbcontroller)));
    });
  }

  @override
  void onSignUpDuplicateEmail() {
    setState(() {
      this.widgets = [ _defaultText("Sign up failed", upperTextSize), _defaultText("There is already an account with this email.", lowerTextSize), _backButton(context) ];
    });
  }

  @override
  void onSignUpDuplicateUsername() {
    setState(() {
      this.widgets = [ _defaultText("Sign up failed", upperTextSize), _defaultText("There is already an account with this username.", lowerTextSize), _backButton(context) ];
    });
  }

  @override
  void onSignUpSuccess() {
    setState(() {
      this.widgets = [ _defaultText("Successfully signed up!", upperTextSize), _toTalksButton(context) ];
    });
  }
}