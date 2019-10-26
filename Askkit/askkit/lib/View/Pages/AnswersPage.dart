import 'dart:math';

import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Widgets/AnswerCard.dart';
import 'package:askkit/View/Widgets/CollectionListViewBuilder.dart';
import 'package:askkit/View/Widgets/QuestionCard.dart';
import 'package:askkit/View/Widgets/UserInputCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';

class AnswersPage extends StatefulWidget {
  final Question _question;

  AnswersPage(this._question);

  @override
  State<StatefulWidget> createState() {
    return AnswersPageState();
  }

}

class AnswersPageState extends State<AnswersPage> {
  final List<Answer> answers = new List();

  final int COMMENT_MAX_LEN = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Question Page"),
            backgroundColor: Colors.indigo[400]
        ),
        body: getBody(),
        floatingActionButton: RaisedButton(child: Icon(Icons.add), onPressed: addComment, color: gray)
    );
  }

  Widget getBody() {
    return Stack(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(top: 100.0),
              child: getCommentView(widget._question)
          ),
          Positioned(
              child: QuestionCard(widget._question, false)
          )
        ]
    );
  }

  Widget getCommentView(Question question) {
    Query query = Answer.getCollection().where("question", isEqualTo: question.reference);
    return makeStreamBuilder(
        query, (document) =>
        Container(
            padding: const EdgeInsets.only(left: 20.0),
            child: AnswerCard(Answer.fromSnapshot(document))
        )
    );
  }

  void addComment() {
    final TextEditingController commentController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                      controller: commentController,
                      decoration: new InputDecoration(
                        hintText: "Comment",
                        labelText: "Enter your comment",
                      ),
                      validator: (String value) {
                        if(value.length == 0)
                          return 'Comment can\'t be empty';
                        else return value.length > COMMENT_MAX_LEN ? 'Comment too big ($COMMENT_MAX_LEN characters max)' : null;
                      }
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        child: Text(
                            "Submit",
                            style: new TextStyle(
                                color: Colors.red
                            )
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          if(!_formKey.currentState.validate())
                            return;
                          Answer.addToCollection(Answer("MOAAS", commentController.text, widget._question.reference));
                          Navigator.pop(context);
                          this.setState(() {});
                        },
                      )
                  )
                ],
              ),
            ),
          );
        });
  }
}