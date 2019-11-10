import 'dart:core';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/AuthListener.dart';
import 'package:askkit/View/TextFieldValidators/LoginValidators.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Controllers/DatabaseController.dart';
import '../Theme.dart';
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
  TextEditingController _confirmPasswordController = TextEditingController();

  static final signUpFormKey = GlobalKey<FormState>();


  static const Color signUpColor = primaryColor;

  bool _hidePassword = true;

  @protected
  void initState() {
    super.initState();
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
        backgroundColor: backgroundColor,
        body: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                titleText("Askkit", 38, EdgeInsets.only(top: 25.0)),
                titleText("Ask away!", 16, EdgeInsets.only(bottom: 25.0)),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    switchSignButton("SIGN IN", () => setState(() => changeToSignIn()), _signInActive),
                    switchSignButton("SIGN UP", () => setState(() => changeToSignUp()), _signUpActive)
                  ],
                ),
                Container(
                    margin: EdgeInsets.all(15.0),
                    child: _signInActive ? _showSignIn() : _showSignUp()),
              ],
            )
          ],
        )
    );
  }

  Widget titleText(String text, double fontSize, EdgeInsets margin) {
    return Container(
      margin: margin,
      child: Text(text, style: Theme
          .of(context)
          .textTheme
          .title
          .copyWith(fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: primaryColor),
    )
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
            child: loginTextField("Password", Icons.lock, _passwordController, isPasswordField: true)
        ),
        FlatButton(
          onPressed: forgotPassword,
          child: Text("Forgot password?", textAlign: TextAlign.left, style: TextStyle(decoration: TextDecoration.underline))
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
    return Form (
      key: signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Enter your email", Icons.email, _newEmailController, validator: LoginValidator.emailValidator())
          ),
          Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Pick a username", Icons.person, _newUsernameController, validator: LoginValidator.usernameValidator())
          ),
          Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Pick a password", Icons.lock, _newPasswordController, isPasswordField: true, validator: LoginValidator.passwordValidator())
          ),
          Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Confirm password", Icons.lock, _confirmPasswordController, isPasswordField: true, validator: LoginValidator.confirmPasswordValidator(_newPasswordController))
          ),
          Container(
              child: loginSubmitButton("Sign up", Icons.arrow_upward, () {
                if(!signUpFormKey.currentState.validate())
                  return;
                widget._dbcontroller.signUp(_newEmailController.text, _newUsernameController.text, _newPasswordController.text, this);
              })
          ),
        ])
    );
  }

  Widget loginTextField(String hint, IconData icon, TextEditingController controller, {bool isPasswordField : false, FormFieldValidator<String> validator}) {
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
      style: Theme.of(context).textTheme.title.copyWith(fontSize: 20.0, fontWeight: FontWeight.normal, color: primaryColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.title.copyWith(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.blueAccent),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)),
        prefixIcon: Icon(icon, color: iconColor),
        suffixIcon: suffixIcon,
      )
    );
  }

  Widget loginSubmitButton(String text, IconData icon, Function onPress) {
    return RaisedButton(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(icon, color: Colors.white),
            Text(
                text,
                style: Theme.of(context).textTheme.title.copyWith(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
              ),
            Icon(null, color: Colors.white),
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
              TextStyle(fontSize: 22, color: primaryColor, fontWeight: FontWeight.bold) :
              TextStyle(fontSize: 16, color: primaryColor, fontWeight: FontWeight.normal)),
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _newEmailController.clear());
    WidgetsBinding.instance.addPostFrameCallback((_) => _newUsernameController.clear());
    WidgetsBinding.instance.addPostFrameCallback((_) => _newPasswordController.clear());
    WidgetsBinding.instance.addPostFrameCallback((_) => _confirmPasswordController.clear());
  }


  void forgotPassword() {
    widget._dbcontroller.sendForgotPassword(_usernameController.text);
    OkDialog("Email sent to ${_usernameController.text}!", "Check your inbox to reset your password.", context).show();
  }
}