import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  BuildContext context;
  List<Widget> actions;
  String title;
  String content;

  CustomDialog({
    this.title = "",
    this.content = "",
    this.actions,
    this.context
  });

  show() {
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: actions
        );
      },
    );
  }
}

class OkDialog extends CustomDialog {
  OkDialog(String title, String content, BuildContext context) : super(
      title: title,
      content: content,
      context: context,
      actions: <Widget>[
        new FlatButton(
          child: new Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ]
  );
}


class VerifyDialog extends CustomDialog {
  VerifyDialog(String title, String content, BuildContext context, DatabaseController dbcontroller) : super(
      title: title,
      content: content,
      context: context,
      actions: <Widget> [
        new FlatButton(
          child: new Text("Resend email"),
          onPressed: () {
            dbcontroller.sendEmailVerification();
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ]
  );
}