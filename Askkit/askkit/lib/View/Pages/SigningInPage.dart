import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/AuthListener.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Pages/LogInPage.dart';
import 'package:askkit/View/Theme.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:askkit/View/Widgets/TitleText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'QuestionsPage.dart';

abstract class SigningPage extends StatefulWidget {
  final DatabaseController _dbcontroller;

  SigningPage(this._dbcontroller);

}

class SigningInPage extends SigningPage {
  final SigningInPageState _state = SigningInPageState("Signing in...");

  SigningInPage(DatabaseController dbcontroller) : super(dbcontroller) {
    this._dbcontroller.signIn("username", "password", _state);
  }

  @override
  State<StatefulWidget> createState() {
    return _state;
  }
}

class SigningUpPage extends SigningPage {
  final SigningInPageState _state = SigningInPageState("Signing up...");

  SigningUpPage(DatabaseController dbcontroller) : super(dbcontroller){
    this._dbcontroller.signUp("email", "username", "password", _state);
  }

  @override
  State<StatefulWidget> createState() {
    return _state;
  }

}

class SigningInPageState extends State<SigningPage> implements SignInListener, SignUpListener {
  String _text;
  SigningInPageState(this._text);

  Widget _actions = Container();



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleText(text: "Askkit", fontSize: 38, margin: EdgeInsets.only(top: 25.0)),
            TitleText(text: "Ask away!", fontSize: 16, margin: EdgeInsets.only(bottom: 25.0)),
            Container(
                margin: EdgeInsets.only(bottom: 25.0),
                child: CircularProgressIndicator()
            ),
            Center(
                child: Text(this._text, style: TextStyle(fontWeight: FontWeight.bold),)
            ),
            _actions
          ],
        )
    );
  }

  @override
  void onSignInIncorrect() {
    setState(() {
      this._text = "Login failed\nThe username or password is not correct.";
    });
    // actions: go back...
    //OkDialog("Login failed", "The username or password is not correct.", context).show();
  }

  @override
  void onSignInSuccess(User user) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuestionsPage(widget._dbcontroller)));
  }

  @override
  void onSignInUnverified() {
    setState(() {
      this._text = "Email not verified\nPlease check your inbox to verify your account.";
    });
    // actions: resend, go back
    //VerifyDialog("Email not verified", "Please check your email to verify your account.", context, widget._dbcontroller).show();
  }

  @override
  void onSignUpDuplicateEmail() {
    setState(() {
      this._text = "Sign up failed\nThere is already an account with this email.";
    });
    // actions: back to register (pop)
    //OkDialog("Sign up failed", "There is already an account with this email.", context).show();
  }

  @override
  void onSignUpDuplicateUsername() {
    setState(() {
      this._text = "Sign up failed\nThere is already an account with this username.";
    });
    // actions: back to register (pop)
    //OkDialog("Sign up failed", "There is already an account with this username.", context).show();
  }

  @override
  void onSignUpSuccess() {
    setState(() {
      this._text = "Successfully signed up!\nPlease check your email to verify your account.";
    });
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInPage(widget._dbcontroller)));
    // actions: back to login (push replacement)
    // OkDialog("Successfully signed up!", "Please check your email to verify your account.", context).show();
  }


}