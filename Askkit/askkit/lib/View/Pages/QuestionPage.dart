import 'dart:math';

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
          backgroundColor: Colors.indigo[400]
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 100.0),
            child: ListView.builder(
                itemCount: 8,
                itemBuilder: (BuildContext context, int i) {
                  var rng = new Random();
                  int random = rng.nextInt(1000);
                  Question question = Question("Moas$random", "Comment$i");
                  return Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: QuestionCard(question)
                  );
                }
            )
          ),
          Positioned(
              child: QuestionCard(widget._question)
          )
        ]
    );
  }
}