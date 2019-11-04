import 'dart:core';
import 'package:askkit/Model/Authenticator.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'QuestionsPage.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key key}) : super(key: key);

  @protected
  @override
  State<StatefulWidget> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _signInActive = true, _signUpActive = false;
  TextEditingController _emailController = TextEditingController();
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
    return Text(text,
        style: Theme
            .of(context)
            .textTheme
            .title
            .copyWith(fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: mainColor)
    );
  }

  void _showOkDialog(String title, String content) {
    print(content == null);
    CustomDialog(
        context: context,
        title: title,
        content: content,
        actions: <Widget> [
          new FlatButton(
            child: new Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ]
    ).show();
  }

  void _showVerifyDialog(String title, String content) {
    CustomDialog(
        context: context,
        title: title,
        content: content,
        actions: <Widget> [
          new FlatButton(
            child: new Text("Resend email"),
            onPressed: () {
              Auth.sendEmailVerification();
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ]
    ).show();
  }

  Future<void> signIn(String email, String password) async {
    try {
      String result = await Auth.signIn(
          _emailController.text, _passwordController.text);
      if (result == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuestionsPage()));
        return;
      }
      if (await Auth.isEmailVerified())
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuestionsPage()));
      else _showVerifyDialog("Email not verified", "Please check your email to verify your account.");
    }
    on PlatformException catch (exception) {
      _showOkDialog("Login failed", "The username or password is not correct.");
    }
  }

  Future<void> signUp(String email, String username, String password) async {
    try {
       await Auth.signUp(email, username, password);
      _showOkDialog("Successfully signed up!", "Please check your email to verify your account.");
    }
    on PlatformException catch (exception) {
      _showOkDialog("Sign up failed", "There is already an account with this email.");
    }
  }




  Widget _showSignIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Username", Icons.person, _emailController)
        ),
        Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Password", Icons.lock, _passwordController, isPasswordField: true)
        ),
        Container(
            child: loginSubmitButton("Sign in", Icons.arrow_forward, () {
              this.signIn(_emailController.text, _passwordController.text);
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
                this.signUp(_newEmailController.text, _newUsernameController.text, _newPasswordController.text);
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
      style: Theme
          .of(context)
          .textTheme
          .title
          .copyWith(
          fontSize: 20.0, fontWeight: FontWeight.normal, color: mainColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme
            .of(context)
            .textTheme
            .title
            .copyWith(
            fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.blueAccent),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Theme
                    .of(context)
                    .accentColor, width: 1.0)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Theme
                    .of(context)
                    .accentColor, width: 2.0)),
        prefixIcon: Icon(
          icon,
          color: iconColor,
        ),
        suffixIcon: suffixIcon
        )
    );
  }

  Widget loginSubmitButton(String text, IconData icon, Function onPress) {
    return RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RawMaterialButton(
              shape: CircleBorder(),
              child: Icon(icon, color: Colors.white),
            ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: Theme
                    .of(context)
                    .textTheme
                    .title
                    .copyWith(fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
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

}