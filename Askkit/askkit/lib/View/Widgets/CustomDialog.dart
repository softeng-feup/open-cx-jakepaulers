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