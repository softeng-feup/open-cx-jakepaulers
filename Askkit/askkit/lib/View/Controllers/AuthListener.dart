import 'package:askkit/Model/User.dart';

abstract class AuthListener {
  void onSignInSuccess(User user);
  void onSignInIncorrect();
  void onSignInUnverified();

  void onSignUpSuccess();
  void onSignUpDuplicate();
}