import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Pages/AnswersPage.dart';
import 'package:askkit/View/Theme.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Borders.dart';

class QuestionCard extends CardTemplate {
    final bool _clickable;
    final Question _question;
    final DatabaseController _dbcontroller;

    QuestionCard(this._question, this._clickable, this._dbcontroller);

  @override
  onClick(BuildContext context) {
    if (!_clickable)
      return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => AnswersPage(_question, _dbcontroller)));
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded(
              flex: 9,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget> [
                        CircleAvatar(
                            radius: 15.0,
                            backgroundImage: _question.user.getImage()
                        ),
                        Text("  " + _question.user.username, style: CardTemplate.usernameStyle),
                      ],
                    ),
                    Container(
                      padding: CardTemplate.contentPadding,
                      child: Text(_question.content, style: CardTemplate.contentStyle),
                      alignment: Alignment.centerLeft,
                    ),
                    Divider(),
                    Row (
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_question.getAgeString(), style: CardTemplate.dateStyle),
                        Text(_question.getCommentsString(), style: CardTemplate.dateStyle),
                      ],
                    )
                  ]
              )
          ),
          Expanded(
              flex: 1,
              child: UpvoteColumn(_question, _dbcontroller)
          )
        ]
    );
  }
}

class UpvoteColumn extends StatefulWidget {
  Question _question;
  DatabaseController _dbcontroller;

  UpvoteColumn(this._question, this._dbcontroller);

  @override
  State<StatefulWidget> createState() => UpvoteColumnState();
}

class UpvoteColumnState extends State<UpvoteColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () => upvote(),
            child: Icon(Icons.keyboard_arrow_up, size: 30.0, color: widget._question.userVote == 1 ? Colors.green : Colors.black)
        ),
        Text("${widget._question.upvotes}"),
        GestureDetector(
            onTap: () => downvote(),
            child: Icon(Icons.keyboard_arrow_down, size: 30.0, color: widget._question.userVote == -1 ? Colors.red : Colors.black)
        ),
      ],
    );
  }

  void upvote() async {
    setState(() {
      widget._question.upvote();
    });
    User user = await widget._dbcontroller.getCurrentUser();
    widget._dbcontroller.setVote(widget._question, user, widget._question.userVote);
  }

  void downvote() async {
    setState(() {
      widget._question.downvote();
    });
    User user = await widget._dbcontroller.getCurrentUser();
    widget._dbcontroller.setVote(widget._question, user, widget._question.userVote);
  }
}