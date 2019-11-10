import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/AuthListener.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Theme.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:askkit/View/Widgets/TitleText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'QuestionsPage.dart';

class SigningInPage extends StatefulWidget {
  String text = "Testerest";
  DatabaseController _dbcontroller;

  SigningInPage(DatabaseController _dbcontroller);

  @override
  State<StatefulWidget> createState() => SigningInPageState();
}

class SigningInPageState extends State<SigningInPage> implements AuthListener{
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
                child: Text(this.widget.text, style: TextStyle(fontWeight: FontWeight.bold),)
            ),
          ],
        )
    );
  }

  @override
  void onSignInIncorrect() {
    OkDialog("Login failed", "The username or password is not correct.", context).show();
  }

  @override
  void onSignInSuccess(User user) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuestionsPage(widget._dbcontroller)));
  }

  @override
  void onSignInUnverified() {
    VerifyDialog("Email not verified", "Please check your email to verify your account.", context, widget._dbcontroller).show();
  }

  @override
  void onSignUpDuplicateEmail() {
    OkDialog("Sign up failed", "There is already an account with this email.", context).show();
  }

  @override
  void onSignUpDuplicateUsername() {
    OkDialog("Sign up failed", "There is already an account with this username.", context).show();
  }

  @override
  void onSignUpSuccess() {
    OkDialog("Successfully signed up!", "Please check your email to verify your account.", context).show();
    //WidgetsBinding.instance.addPostFrameCallback((_) => _newEmailController.clear());
   // WidgetsBinding.instance.addPostFrameCallback((_) => _newUsernameController.clear());
   // WidgetsBinding.instance.addPostFrameCallback((_) => _newPasswordController.clear());
   // WidgetsBinding.instance.addPostFrameCallback((_) => _confirmPasswordController.clear());
  }


}