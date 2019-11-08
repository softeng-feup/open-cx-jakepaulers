import 'dart:core';
import 'package:askkit/Controller/Authenticator.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/AuthListener.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Controllers/DatabaseController.dart';
import 'QuestionsPage.dart';

class LogInPage extends StatefulWidget {
  DatabaseController _dbcontroller;

  LogInPage(DatabaseController controller) {
    this._dbcontroller = controller;
  }

  @protected
  @override
  State<StatefulWidget> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> implements AuthListener {
  bool _signInActive = true, _signUpActive = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _newUsernameController = TextEditingController();
  TextEditingController _newEmailController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  static const Color backgroundColor = Colors.white;
  static const Color mainColor = Colors.blueAccent;
  static const Color iconColor = Colors.black;
  static const Color signUpColor = mainColor;
  static const usernameMinLength = 8;
  static const passwordMinLength = 6;

  static const String emailRegex = "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$";

  bool _hidePassword = true;
 // bool keyboardvisible = false;

  @protected
  void initState() {
    super.initState();

    //KeyboardVisibilityNotification().addNewListener(
    //  onChange: (bool visible) {
    //     this.keyboardvisible = visible;
    //  },
    //);
  }


  changeToSignIn() {
    this._signInActive = true;
    this._signUpActive = false;
  }

  changeToSignUp() {
    this._signInActive = false;
    this._signUpActive = true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        body: Container(
            color: backgroundColor,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      titleText("Askkit", 34),
                      titleText("Ask away!", 14)
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      switchSignButton("SIGN IN", () => setState(() => changeToSignIn()), _signInActive),
                      switchSignButton("SIGN UP", () => setState(() => changeToSignUp()), _signUpActive)
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                    child: _signInActive ? _showSignIn() : _showSignUp()),
              ],
            )
        )
    );
  }

  Widget titleText(String text, double fontSize) {
   // if (this.keyboardvisible)
   //   return Container();
    return Text(text, style: Theme
            .of(context)
            .textTheme
            .title
            .copyWith(fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: mainColor)
    );
  }

  Widget _showSignIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Username", Icons.person, _usernameController)
        ),
        Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Password", Icons.lock, _passwordController, isPasswordField: true)
        ),
        Container(
            child: loginSubmitButton("Sign in", Icons.arrow_forward, () {
              widget._dbcontroller.signIn(_usernameController.text, _passwordController.text, this);
            })
        ),
      ],
    );
  }

  Widget _showSignUp() {
    final formKey = GlobalKey<FormState>();

    return Form (
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: loginTextField("Enter your email", Icons.email, _newEmailController,
                validator: (String value) {
                  RegExp regex = new RegExp(emailRegex, caseSensitive: false);
                  if (regex.hasMatch(value))
                    return null;
                  return "Invalid email";
                }
            )
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: loginTextField("Pick a username", Icons.person, _newUsernameController,
                validator: (String value) {
                  if (value.length < usernameMinLength)
                    return "Username must be at least $usernameMinLength characters long";
                  return null;
                }
            )
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
            child: loginTextField("Pick a password", Icons.lock, _newPasswordController, isPasswordField: true,
                validator: (String value) {
                  if (value.length < passwordMinLength)
                    return "Password must be at least $passwordMinLength characters long";
                  return null;
                }
            ),
          ),
          Container(
              child: loginSubmitButton("Sign up", Icons.arrow_upward, () {
                if(!formKey.currentState.validate())
                  return;
                widget._dbcontroller.signUp(_newEmailController.text, _newUsernameController.text, _newPasswordController.text, this);
              })
          ),
        ])
    );
  }

  Widget loginTextField(String hint, IconData icon, TextEditingController controller, {bool isPasswordField : false, Function validator}) {
    IconButton suffixIcon;
    if (isPasswordField)
      suffixIcon = IconButton(
          color: iconColor,
          icon: _hidePassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
          onPressed: () { setState(() { _hidePassword = !_hidePassword; }); }
      );
    else suffixIcon = IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {  WidgetsBinding.instance.addPostFrameCallback((_) => controller.clear()); },
        color: iconColor
    );
    return TextFormField(
      obscureText: isPasswordField && _hidePassword,
      controller: controller,
      validator: validator,
      style: Theme.of(context).textTheme.title.copyWith(fontSize: 20.0, fontWeight: FontWeight.normal, color: mainColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.title.copyWith(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.blueAccent),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
        prefixIcon: Icon(icon, color: iconColor),
        suffixIcon: suffixIcon
      )
    );
  }

  Widget loginSubmitButton(String text, IconData icon, Function onPress) {
    return RaisedButton(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title.copyWith(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
              ),
            )
          ],
        ),
        color: signUpColor,
        onPressed: onPress
    );
  }

  Widget switchSignButton(String text, Function onPressed, bool active) {
    return OutlineButton(
      onPressed: onPressed,
      borderSide: new BorderSide(
        style: BorderStyle.none,
      ),
      child: new Text(text,
          style: active ?
              TextStyle(fontSize: 22, color: mainColor, fontWeight: FontWeight.bold) :
              TextStyle(fontSize: 16, color: mainColor, fontWeight: FontWeight.normal)),
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
  void onSignUpDuplicate() {
    OkDialog("Sign up failed", "There is already an account with this email.", context).show();
  }

  @override
  void onSignUpSuccess() {
    OkDialog("Successfully signed up!", "Please check your email to verify your account.", context).show();
  }

}