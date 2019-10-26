import 'package:askkit/Model/UserInput.dart';
import 'package:askkit/View/Pages/AnswersPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';
import 'CardTemplate.dart';

class UserInputCard extends CardTemplate {
  final bool _clickable;
  final UserInput _question;
  UserInputCard(this._question, this._clickable);

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
            Text(_question.username)
          ],
        ),
        Container(
          child: Text(_question.text, textScaleFactor: 1.3),
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
    if(this._clickable)
      Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionPage(_question)));
  }

  @override
  Color getCardColor() {
    return lightGray;
  }
}