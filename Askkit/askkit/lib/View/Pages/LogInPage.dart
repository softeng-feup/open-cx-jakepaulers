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
            child: ListView(
              children: <Widget>[
                Container(
                  child: Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("AskKit",
                              style: Theme.of(context).textTheme.title.copyWith(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)
                          ),
                          Text(
                              "Ask away!",
                              style: Theme.of(context).textTheme.title.copyWith(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white)
                          ),
                        ],
                      )),
                  width: 750,
                  height: 120,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    child: IntrinsicWidth(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          OutlineButton(
                            onPressed: () =>
                                setState(() => changeToSignIn()),
                            borderSide: new BorderSide(
                              style: BorderStyle.none,
                            ),
                            child: new Text("SIGN IN",
                                style: _signInActive
                                    ? TextStyle(
                                    fontSize: 22,
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.bold)
                                    : TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.normal)),
                          ),
                          OutlineButton(
                            onPressed: () =>
                                setState(() => changeToSignUp()),
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                            ),
                            child: Text("SIGN UP",
                                style: _signUpActive
                                    ? TextStyle(
                                    fontSize: 22,
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.bold)
                                    : TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.normal)),
                          )
                        ],
                      ),
                    ),
                  ),
                  width: 750,
                  height: 80,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    child: Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: _signInActive ? _showSignIn(context) : _showSignUp()),
                    width: 750,
                    height: 778
                ),
              ],
            )
        )
    );
  }

  Widget _showSignIn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              style: TextStyle(color: Colors.indigo),
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: Theme.of(context).textTheme.title.copyWith(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
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
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              ),
              obscureText: false,
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: true,
              style: TextStyle(color: Colors.indigo),
              controller: _passwordController,
              decoration: InputDecoration(
                //Add th Hint text here.
                hintText: "Password",
                hintStyle: Theme.of(context).textTheme.title.copyWith(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
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
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 80,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: RaisedButton(
                child: Row(
                  children: <Widget>[
                    RawMaterialButton(
                      shape: CircleBorder(),
                      child: Icon(Icons.mail, color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        "Sign in",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title.copyWith(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
                      ),
                    )
                  ],
                ),
                color: Colors.blueGrey,
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConferencePage()))
              /*Controller.tryToLogInUserViaEmail(
                      context, _emailController, _passwordController),*/
            ),
          ),
        ),
      ],
    );
  }

  Widget _showSignUp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: false,
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
              controller: _newEmailController,
              decoration: InputDecoration(
                //Add th Hint text here.
                hintText: "Enter your email",
                hintStyle: Theme.of(context).textTheme.title.copyWith(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
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
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: true,
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
              controller: _newPasswordController,
              decoration: InputDecoration(
                //Add the Hint text here.
                hintText: "Enter a password",
                hintStyle: Theme.of(context).textTheme.title.copyWith(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
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
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 80,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RawMaterialButton(
                      shape: CircleBorder(),
                      child: Icon(Icons.mail, color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title.copyWith(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
                      ),
                    )
                  ],
                ),
                color: Colors.blueGrey,
                onPressed: () => {}
              /*Controller.signUpWithEmailAndPassword(
                      _newEmailController, _newPasswordController),*/
            ),
          ),
        ),
      ],
    );
  }

  Widget horizontalLine() =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: 120,
          height: 1.0,
          color: Colors.indigo.withOpacity(0.6),
        ),
      );
}