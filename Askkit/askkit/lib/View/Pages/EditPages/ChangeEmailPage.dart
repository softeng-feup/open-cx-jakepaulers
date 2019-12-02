import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/AuthListener.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/TextFieldValidators/LoginValidators.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:flutter/material.dart';

class ChangeEmailPage extends StatelessWidget implements AuthListener {
  final DatabaseController _dbcontroller;
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController newEmailController = new TextEditingController();
  final TextEditingController emailCheckController = new TextEditingController();

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool wrongPassword = false;

  ChangeEmailPage(this._dbcontroller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text("Change Email"),
          actions: <Widget>[
            FlatButton(child: Icon(Icons.check, color: Colors.white), onPressed: () => _onSubmitPressed(context))
          ],
        ),
        body: Form(
            key: formKey,
            child: Column(
                children: <Widget>[
                  _makeTextField(context, "Password", passwordController, obscureText: true,
                      validator: (String value) {
                        if (!wrongPassword)
                          return null;
                        wrongPassword = false;
                        return "Wrong password";
                      }
                  ),
                  _makeTextField(context, "New Email", newEmailController, validator: LoginValidator.emailValidator()),
                  _makeTextField(context, "Confirm email", emailCheckController, validator: LoginValidator.confirmEmailValidator(newEmailController))
                ]
            )
        )
    );
  }

  Widget _makeTextField(BuildContext context, String hint, TextEditingController controller, {bool obscureText = false, String Function(String) validator}) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: TextFormField(
            style: Theme.of(context).textTheme.body2.copyWith(fontWeight: FontWeight.normal),
            decoration: InputDecoration(hintText: hint),
            obscureText: obscureText,
            validator: validator,
            controller: controller
        )
    );
  }

  void _onSubmitPressed(BuildContext context) async {
    if (!validateForm())
      return;
    await _dbcontroller.signIn(_dbcontroller.getCurrentUser().username, passwordController.text, this);

    if (wrongPassword) {
      validateForm();
      return;
    }


    ConfirmDialog(
        context: context,
        title: "Change email?",
        content: "You won't be able to use the old one to recover your password.",
        yesPressed: () async {
          await _dbcontroller.changeEmail(newEmailController.text);
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