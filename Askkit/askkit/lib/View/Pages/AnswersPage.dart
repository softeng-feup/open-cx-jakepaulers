import 'dart:math';

import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
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
  List<Answer> answers = new List();
  bool loaded = false;

  final int COMMENT_MAX_LEN = 80;


  @override
  void initState() {
    this.fetchAnswers();
  }

  void fetchAnswers() async {
    loaded = false;
    answers = new List();
    QuerySnapshot questionSnapshot = await Answer.getCollection().where("question", isEqualTo: widget._question.reference).getDocuments();
    for (DocumentSnapshot document in questionSnapshot.documents) {
      User user = await User.fetchUser(document.data['username']);
      answers.add(Answer.fromSnapshot(user, document));
    }
    loaded = true;
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Question Page"),
            backgroundColor: Colors.indigo[400]
        ),
        body: getBody(),
        floatingActionButton: RaisedButton(child: Icon(Icons.add), onPressed: addAnswer, color: gray)
    );
  }



  Widget getBody() {
    return Stack(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(top: 100.0),
              child: getAnswerView(widget._question)
          ),
          Positioned(
              child: QuestionCard(widget._question, false)
          )
        ]
    );
  }

  Widget getAnswerView(Question question) {
    if (!this.loaded)
      return LinearProgressIndicator();
    return ListView.builder(
        itemCount: answers.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
              padding: const EdgeInsets.only(left: 20.0),
              child: AnswerCard(answers[i])
          );
        }
    );
  }

  void addAnswer() {
    final TextEditingController answerController = TextEditingController();
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
                      controller: answerController,
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
                          User.fetchUser("Reply Guy").then((user) {
                            Answer.addToCollection(Answer(user, answerController.text, widget._question.reference));
                            fetchAnswers();
                          });
                          Navigator.pop(context);
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