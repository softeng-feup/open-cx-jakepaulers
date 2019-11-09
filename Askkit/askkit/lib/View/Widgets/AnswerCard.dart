import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Comment.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class AnswerCard extends CardTemplate {
  final Answer _answer;


  AnswerCard(this._answer);

  @override
  onClick(BuildContext context) {

  }

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                  radius: 15.0,
                  backgroundImage: _answer.user.getImage()
              ),
              Text("  " + _answer.user.username, style: CardTemplate.usernameStyle),
              Spacer(),
              Text(_answer.getAgeString(), style: CardTemplate.dateStyle, textAlign: TextAlign.end),
            ],
          ),
          Container(
            padding: CardTemplate.contentPadding,
            child: Text(_answer.content, style: CardTemplate.contentStyle),
            alignment: Alignment.centerLeft,
          ),
        ]
    );
  }
}