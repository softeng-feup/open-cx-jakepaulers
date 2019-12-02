import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/AuthListener.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/TextFieldValidators/LoginValidators.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget implements AuthListener {
  final DatabaseController _dbcontroller;
  final TextEditingController oldPasswordController = new TextEditingController();
  final TextEditingController newPasswordController = new TextEditingController();
  final TextEditingController passwordCheckController = new TextEditingController();

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool wrongPassword = false;

  ChangePasswordPage(this._dbcontroller);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text("Change Password"),
          actions: <Widget>[
            FlatButton(child: Icon(Icons.check, color: Colors.white), onPressed: () => _onSubmitPressed(context))
          ],
        ),
        body: Form(
          key: formKey,
          child: Column(
              children: <Widget>[
                _makeTextField(context, "Old password", oldPasswordController,
                  validator: (String value) {
                    if (!wrongPassword)
                      return null;
                    wrongPassword = false;
                    return "Wrong password";
                  },
                ),
                _makeTextField(context, "New Password", newPasswordController, validator: LoginValidator.passwordValidator()),
                _makeTextField(context, "Confirm Password", passwordCheckController, validator: LoginValidator.confirmPasswordValidator(newPasswordController))
          ],
        )
    ));
  }

  Widget _makeTextField(BuildContext context, String hint, TextEditingController controller, {String Function(String) validator}) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: TextFormField(
            style: Theme.of(context).textTheme.body2.copyWith(fontWeight: FontWeight.normal),
            decoration: InputDecoration(hintText: hint),
            obscureText: true,
            validator: validator,
            controller: controller
        )
    );
  }

  void _onSubmitPressed(BuildContext context) async {
    if (!validateForm())
      return;
    await _dbcontroller.signIn(_dbcontroller.getCurrentUser().username, oldPasswordController.text, this);

    if (wrongPassword) {
      validateForm();
      return;
    }


    ConfirmDialog(
        context: context,
        title: "Change password?",
        content: "You'll need to use this one the next time you try to sign in.",
        yesPressed: () async {
          await _dbcontroller.changePassword(newPasswordController.text);
          Navigator.pop(context);
        },
        noPressed: () {}
    ).show();

  }

  bool validateForm() {
    return formKey.currentState.validate();
  }

  @override void onSignInIncorrect() {
    wrongPassword = true;
  }

  @override void onSignInSuccess(User user) {}
  @override void onSignUpDuplicateEmail() {}
  @override void onSignUpDuplicateUsername() {}
  @override void onSignUpSuccess() {}
}