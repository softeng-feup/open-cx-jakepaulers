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
  TextEditingController _newEmailController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                /*stops: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8],
                colors: [
                  Colors.pink,
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.indigo,
                  Colors.purple
                ],*/
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  Colors.indigo[400],
                  Colors.indigo[300],
                  Colors.indigo[200],
                  Colors.indigo[100],
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("AskKit",
                          style: Theme
                              .of(context)
                              .textTheme
                              .title
                              .copyWith(fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)
                      ),
                      Text(
                          "Ask away!",
                          style: Theme
                              .of(context)
                              .textTheme
                              .title
                              .copyWith(fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white)
                      ),
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
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
                    child: _signInActive ? _showSignIn() : _showSignUp()),
              ],
            )
        )
    );
  }

  Widget _showSignIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Email", Icons.email, _emailController)
        ),
        Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Password", Icons.lock, _passwordController)
        ),
        Container(
            child: loginSubmitButton("Sign in", Icons.arrow_forward,  () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuestionsPage())))
          ),
      ],
    );
  }

  Widget _showSignUp() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Enter an email", Icons.email, _newEmailController),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: loginTextField("Pick a password", Icons.lock, _newPasswordController),
          ),
          Container(
              child: loginSubmitButton("Sign up", Icons.arrow_upward, () {})
          ),
        ]);
  }

  Widget horizontalLine() =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: 1.0,
          color: Colors.redAccent.withOpacity(0.6),
        ),
      );

  Widget loginTextField(String hint, IconData icon, TextEditingController controller) {
    return TextField(
      obscureText: false,
      style: Theme
          .of(context)
          .textTheme
          .title
          .copyWith(
          fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme
            .of(context)
            .textTheme
            .title
            .copyWith(
            fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Theme
                    .of(context)
                    .accentColor, width: 1.0)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Theme
                    .of(context)
                    .accentColor, width: 1.0)),
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
      ),
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
        color: Colors.blueGrey,
        onPressed: onPress
      /*Controller.signUpWithEmailAndPassword(
                      _newEmailController, _newPasswordController),*/
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
              TextStyle(fontSize: 22, color: Colors.amber, fontWeight: FontWeight.bold) :
              TextStyle(fontSize: 16, color: Colors.amber, fontWeight: FontWeight.normal)),
    );
  }
}