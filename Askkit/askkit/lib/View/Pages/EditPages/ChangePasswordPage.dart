import 'package:askkit/Controller/Authenticator.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  DatabaseController _dbcontroller;
  static TextEditingController oldPasswordController = new TextEditingController();
  static TextEditingController newPasswordController = new TextEditingController();
  static TextEditingController passwordCheckController = new TextEditingController();

  static final GlobalKey<FormState> oldPasswordKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> newPasswordKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> passwordCheckKey = GlobalKey<FormState>();

  bool wrongPassword = false;

  ChangePasswordPage(this._dbcontroller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text("Change Password"),
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
                    Text("Old Password: "),
                    Expanded(
                        child: Form(
                            key: oldPasswordKey,
                            child: TextFormField(
                              obscureText: true,
                              validator: (String value) {
                                if (wrongPassword) {
                                  wrongPassword = false;
                                  return "Wrong password";
                                }
                                return null;
                              },
                              controller: oldPasswordController,
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
                    Text("New Password: "),
                    Expanded(
                        child: Form(
                            key: newPasswordKey,
                            child: TextFormField(
                              obscureText: true,
                              validator: (String value) {
                                if (value.length < 8)
                                  return "Password must be at least 8 characters";
                                return null;
                              },
                              controller: newPasswordController,
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
                    Text("Repeat password: "),
                    Expanded(
                        child: Form(
                            key: passwordCheckKey,
                            child: TextFormField(
                              obscureText: true,
                              validator: (String value) {
                                if (value.length < 8)
                                  return "Password must be at least 8 characters";
                                if (value != newPasswordController.text)
                                  return "Passwords must match";
                                return null;
                              },
                              controller: passwordCheckController,
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

    /*try {
      print(_dbcontroller.getCurrentUser().email);
      print(oldPasswordController.text);
      await Auth.reauthenticate(oldPasswordController.text);
    }catch(e){
      print(e.toString());
      return;
    }*/
    try {
      await Auth.signIn((await Auth.getCurrentUser()).email, oldPasswordController.text);
    } catch (e) {
      wrongPassword = true;
      oldPasswordKey.currentState.validate();
      return;
    }

    await _dbcontroller.changePassword(newPasswordController.text);
    oldPasswordController.clear();
    newPasswordController.clear();
    passwordCheckController.clear();
    Navigator.pop(context);
  }

  bool validateForm() {
    return (newPasswordKey.currentState.validate() && passwordCheckKey.currentState.validate());
  }
}