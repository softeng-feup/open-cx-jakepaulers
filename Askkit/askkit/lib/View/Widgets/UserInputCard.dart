import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Pages/AnswersPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';
import 'CardTemplate.dart';

class UserInputCard extends CardTemplate {
  final bool _clickable;
  final Comment _comment;
  UserInputCard(this._comment, this._clickable);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget> [
            CircleAvatar(
              backgroundColor: getCardColor(),
              backgroundImage: NetworkImage('https://noticias.up.pt//wp-content/uploads/2019/05/Pedro-Mo%C3%A1s-interior-e1556272376936.jpg'),
            ),
            Text(" "),
            Text(_comment.username)
          ],
        ),
        Container(
          child: Text(_comment.content, textScaleFactor: 1.3),
          alignment: Alignment.centerLeft,
        ),
      ]
    );
  }

  @override
  onClick(BuildContext context) {
    if(this._clickable) {
      Question question = _comment;
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => QuestionPage(question)));
    }
  }

  @override
  Color getCardColor() {
    return lightGray;
  }
}