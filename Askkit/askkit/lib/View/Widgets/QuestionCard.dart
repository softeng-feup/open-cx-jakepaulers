import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Pages/AnswersPage.dart';
import 'package:askkit/View/Theme.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:askkit/View/Widgets/UserInputCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class QuestionCard extends UserInputCard {
    final bool _clickable;
    final Question _question;
    final DatabaseController _dbcontroller;

    QuestionCard(this._question, this._clickable, this._dbcontroller);

  @override
  Comment getComment() {
    return _question;
  }

  @override
  onClick(BuildContext context) {
    if (!_clickable)
      return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => AnswersPage(_question, _dbcontroller)));
  }

  //TEMPORARIO
  @override
  Widget buildCardContent(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded(
              flex: 9,
              child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget> [
                        CircleAvatar(
                            backgroundColor: lightGray,
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
  void initState() {
    updateUserVote();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () => upvote(),
            child: Icon(Icons.keyboard_arrow_up, color: widget._question.userVote == 1 ? Colors.green : Colors.black)
        ),
        Text("${widget._question.upvotes}"),
        GestureDetector(
            onTap: () => downvote(),
            child: Icon(Icons.keyboard_arrow_down, color: widget._question.userVote == -1 ? Colors.red : Colors.black)
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

  void updateUserVote() async {
    User currentUser = await widget._dbcontroller.getCurrentUser();
    print(currentUser.username);
    print(currentUser.email);
    widget._question.userVote = await widget._dbcontroller.getUserUpvote(widget._question, currentUser);
    print(widget._question.content + " - " + widget._question.userVote.toString());
    setState(() {});
  }
}