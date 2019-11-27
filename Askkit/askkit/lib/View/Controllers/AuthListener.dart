import 'package:askkit/Model/User.dart';

abstract class AuthListener {
  void onSignUpSuccess();
  void onSignUpDuplicateEmail();
  void onSignUpDuplicateUsername();

  void onSignInSuccess(User user);
  void onSignInIncorrect();
}