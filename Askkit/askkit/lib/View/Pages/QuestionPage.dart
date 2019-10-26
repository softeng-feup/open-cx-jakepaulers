import 'dart:math';

import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Widgets/CollectionListViewBuilder.dart';
import 'package:askkit/View/Widgets/QuestionCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
            child: this.makeCommentView(widget._question)
          ),
          Positioned(
              child: QuestionCard(widget._question)
          )
        ]
    );
  }

  Widget makeCommentView(Question question) {
    Query query = Answer.getCollection().where("question", isEqualTo: question.reference);
    return makeStreamBuilder(
        query, (document) =>
        Container(
            padding: const EdgeInsets.only(left: 20.0),
            child: QuestionCard(Question.fromSnapshot(document))
        )
    );
  }
}
