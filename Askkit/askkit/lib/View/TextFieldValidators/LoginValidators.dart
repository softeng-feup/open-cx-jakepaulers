import 'package:flutter/material.dart';

class LoginValidator {
  static const usernameMinLength = 6;
  static const passwordMinLength = 6;
  static const String emailRegex = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static FormFieldValidator<String> usernameValidator() {
    return (String value) {
      if (value.length < usernameMinLength)
        return "Username must be at least $usernameMinLength characters long";
      return null;
    };
  }


  static FormFieldValidator<String> emailValidator() {
    return (String value) {
      RegExp regex = new RegExp(emailRegex, caseSensitive: false);
      if (regex.hasMatch(value))
        return null;
      return "Invalid email";
    };
  }


  static FormFieldValidator<String> passwordValidator() {
    return (String value) {
      if (value.length < passwordMinLength)
        return "Password must be at least $passwordMinLength characters long";
      return null;
    };
  }

  static FormFieldValidator<String> confirmPasswordValidator(TextEditingController passwordController) {
    return (String value) {
      if (value != passwordController.text)
        return "Passwords do not match";
      return null;
    };
  }

  static FormFieldValidator<String> confirmEmailValidator(TextEditingController emailController) {
    return (String value) {
      if (value != emailController.text)
        return "Emails do not match";
      return null;
    };
  }

}