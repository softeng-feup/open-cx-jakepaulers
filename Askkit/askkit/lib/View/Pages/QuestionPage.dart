import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Widgets/QuestionCard.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';

class QuestionPage extends StatefulWidget {
  final Question _question;

  QuestionPage(this._question);

  @override
  State<StatefulWidget> createState() {
    return QuestionPageState();
  }

}

class QuestionPageState extends State<QuestionPage> {
  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Question Page"),
          backgroundColor: Colors.red
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Text("OLA");
  }
}