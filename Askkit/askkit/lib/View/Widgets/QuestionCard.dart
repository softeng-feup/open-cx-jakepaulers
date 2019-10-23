import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Pages/QuestionPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';
import 'CardTemplate.dart';

class QuestionCard extends CardTemplate {
  Question question;
  QuestionCard(this.question);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget> [
            CircleAvatar(
              backgroundColor: lightGray,
              backgroundImage: NetworkImage('https://noticias.up.pt//wp-content/uploads/2019/05/Pedro-Mo%C3%A1s-interior-e1556272376936.jpg'),
            ),
            Text(" "),
            Text(question.username)
          ],
        ),
        Container(
          child: Text(question.text, textScaleFactor: 1.3),
          alignment: Alignment.centerLeft,
        ),
      ]
    );
  }

  @override
  String getTitle() {
    return "Question :D";
  }

  @override
  onClick(BuildContext context) {
    return QuestionPage(question);
  }

  @override
  Color getCardColor() {
    return lightGray;
  }
}