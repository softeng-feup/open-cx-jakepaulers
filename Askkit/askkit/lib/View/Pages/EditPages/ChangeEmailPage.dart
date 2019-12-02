import 'package:askkit/Controller/Authenticator.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/TextFieldValidators/LoginValidators.dart';
import 'package:flutter/material.dart';

class ChangeEmailPage extends StatelessWidget {
  DatabaseController _dbcontroller;
  static TextEditingController passwordController = new TextEditingController();
  static TextEditingController newEmailController = new TextEditingController();
  static TextEditingController emailChecKController = new TextEditingController();

  static final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> newEmailKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> emailCheckKey = GlobalKey<FormState>();

  bool wrongPassword = false;

  ChangeEmailPage(this._dbcontroller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text("Change Email"),
          actions: <Widget>[
            FlatButton(child: Icon(Icons.save, color: Colors.white), onPressed: () => _onSubmitPressed(context))
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Text("Password: "),
                    Expanded(
                        child: Form(
                            key: passwordKey,
                            child: TextFormField(
                              obscureText: true,
                              validator: (String value) {
                                if (wrongPassword) {
                                  wrongPassword = false;
                                  return "Wrong password";
                                }
                                return null;
                              },
                              controller: passwordController,
                            )
                        )
                    )
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child:Row(
                  children: <Widget>[
                    Text("New Email: "),
                    Expanded(
                        child: Form(
                            key: newEmailKey,
                            child: TextFormField(
                              validator: LoginValidator.emailValidator(),
                              controller: newEmailController,
                            )
                        )
                    )
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Text("Repeat email: "),
                    Expanded(
                        child: Form(
                            key: emailCheckKey,
                            child: TextFormField(
                              validator: (String value) {
                                if (value != newEmailController.text)
                                  return "Emails must match";
                                return null;
                              },
                              controller: emailChecKController,
                            )
                        )
                    )
                  ],
                )
            )
          ],
        )
    );
  }

  void _onSubmitPressed(BuildContext context) async {
    if (!validateForm())
      return;

    try {
      await Auth.signIn((await Auth.getCurrentUser()).email, passwordController.text);
    } catch (e) {
      wrongPassword = true;
      passwordKey.currentState.validate();
      return;
    }

    await _dbcontroller.changeEmail(newEmailController.text);
    passwordController.clear();
    newEmailController.clear();
    emailChecKController.clear();
    Navigator.pop(context);
  }

  bool validateForm() {
    return (newEmailKey.currentState.validate() && emailCheckKey.currentState.validate());
  }
}