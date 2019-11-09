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
  Comment getComment() {
    return _answer;
  }

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
                  backgroundImage: getComment().user.getImage()
              ),
              Text("  " + getComment().user.username, style: CardTemplate.usernameStyle)
            ],
          ),
          Container(
            padding: CardTemplate.contentPadding,
            child: Text(getComment().content, style: CardTemplate.contentStyle),
            alignment: Alignment.centerLeft,
          ),
        ]
    );
  }
}