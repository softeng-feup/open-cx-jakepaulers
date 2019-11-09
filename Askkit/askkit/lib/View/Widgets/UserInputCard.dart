import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Pages/AnswersPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';
import 'CardTemplate.dart';

abstract class UserInputCard extends CardTemplate {
  Comment getComment();


  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget> [
            CircleAvatar(
              backgroundColor: getCardColor(),
              backgroundImage: getComment().user.getImage()
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
    );
  }

  @override
  Color getCardColor() {
    return lightGray;
  }

}