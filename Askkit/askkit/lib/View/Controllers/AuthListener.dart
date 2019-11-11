import 'package:askkit/Model/User.dart';

abstract class SignInListener {
  void onSignInSuccess(User user);
  void onSignInIncorrect();
  void onSignInUnverified();
}

abstract class SignUpListener {
  void onSignUpSuccess();
  void onSignUpDuplicateEmail();
  void onSignUpDuplicateUsername();
}