

import 'package:askkit/Controller/Authenticator.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/TextFieldValidators/LoginValidators.dart';
import 'package:askkit/View/Widgets/CustomTextForm.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  DatabaseController _dbcontroller;
  static TextEditingController oldPasswordController = new TextEditingController();
  static TextEditingController newPasswordController = new TextEditingController();
  static TextEditingController passwordCheckController = new TextEditingController();

  static final GlobalKey<FormState> oldPasswordKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> newPasswordKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> passwordCheckKey = GlobalKey<FormState>();

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
            Row(
              children: <Widget>[
                Text("Old Password: "),
                Container(
                    width: 250.0,
                    child: Form(
                        key: oldPasswordKey,
                        child: TextFormField(
                          obscureText: true,
                          validator: (String value) {
                            if (value.length < 8)
                              return "Password must be at least 8 characters";
                            return null;
                          },
                          controller: oldPasswordController,
                        )
                    )
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text("New Password: "),
                Container(
                  width: 250.0,
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
            ),
            Row(
              children: <Widget>[
                Text("Repeat password: "),
                Container(
                    width: 250.0,
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
            ),
          ],
        )
    );
  }

  void _onSubmitPressed(BuildContext context) async {
    if (!validateForm())
      return;

    try {
      print(_dbcontroller.getCurrentUser().email);
      await Auth.reauthenticate(oldPasswordController.text);
    }catch(ERROR_INVALID_CREDENTIAL){
      print("Wrong password");
      return;
    }

    _dbcontroller.changePassword(newPasswordController.text);
    Navigator.pop(context);
  }

  bool validateForm() {
    return (newPasswordKey.currentState.validate() && passwordCheckKey.currentState.validate());
  }
}