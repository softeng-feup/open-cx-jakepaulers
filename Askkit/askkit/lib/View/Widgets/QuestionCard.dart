import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Pages/AnswersPage.dart';
import 'package:askkit/View/Widgets/UserInputCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class QuestionCard extends UserInputCard {
  final bool _clickable;
  final Question _question;

  QuestionCard(this._question, this._clickable);

  @override
  Comment getComment() {
    return _question;
  }

  @override
  onClick(BuildContext context) {
    if (!_clickable)
      return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => AnswersPage(_question)));

  }

  //TEMPORARIO
  @override
  Widget buildCardContent(BuildContext context) {
    int upvotes = _question.upvotes;
    return Row(
        children: <Widget>[
          Expanded(
              flex: 9,
              child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget> [
                        CircleAvatar(
                            backgroundColor: getCardColor(),
                            backgroundImage: getComment().user.image
                        ),
                        Text(" "),
                        Text(getComment().user.username)
                      ],
                    ),
                    Container(
                      child: Text(getComment().content, textScaleFactor: 1.3),
                      alignment: Alignment.centerLeft,
                    ),
                  ]
              )
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {print("UPVOTE!");},
                      child: Icon(Icons.keyboard_arrow_up, color: Colors.green)
                  ),
                  Text("$upvotes"),
                  GestureDetector(
                      onTap: () {print("DOWNVOTE!");},
                      child: Icon(Icons.keyboard_arrow_down, color: Colors.red)
                  ),
                ],
              )
          )
        ]
    );
  }

}