import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Pages/AnswersPage.dart';
import 'package:askkit/View/Widgets/UserInputCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
              child: upvoteColumn(_question)
          )
        ]
    );
  }
}

class upvoteColumn extends StatefulWidget {
  Question _question;
  upvoteColumn(this._question);

  @override
  State<StatefulWidget> createState() => upvoteColumnState(_question);
}

class upvoteColumnState extends State<upvoteColumn> {
  Question _question;
  int upvoted = 0;

  upvoteColumnState(this._question);

  @override
  void initState() {
    _question.updateUpvotes();
    checkIfUpvoted();
  }

  @override
  Widget build(BuildContext context) {
    int upvotes = _question.upvotes;
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () => upvote(),
            child: Icon(Icons.keyboard_arrow_up,
                color: upvoted == 1 ? Colors.green : Colors.black)
        ),
        Text("$upvotes"),
        GestureDetector(
            onTap: () => downvote(),
            child: Icon(Icons.keyboard_arrow_down,
                color: upvoted == -1 ? Colors.red : Colors.black)
        ),
      ],
    );
  }

  upvote() async {
    User user = await User.fetchUser("HenriJSantos");
    QuerySnapshot upvotesSnapshot = await Question.getUpvoteCollection().where(
        "question", isEqualTo: _question.reference).where(
        "user", isEqualTo: user.reference).getDocuments();
    if (upvotesSnapshot.documents.isEmpty) {
      upvoted = 1;
      _question.upvotes++;
      setState(() {});
      await Question.getUpvoteCollection().add({
        'question': _question.reference,
        'user': user.reference,
        'value': 1
      });
    } else {
      final WriteBatch batch = Firestore.instance.batch();
      batch.delete(upvotesSnapshot.documents[0].reference);
      await batch.commit();
      if (upvotesSnapshot.documents[0]['value'] == 1) {
        upvoted = 0;
        _question.upvotes--;
        setState(() {});
      } else {
        upvoted = 1;
        _question.upvotes+=2;
        setState(() {});
        await Question.getUpvoteCollection().add({
          'question': _question.reference,
          'user': user.reference,
          'value': 1
        });
      }
    }
    await _question.updateUpvotes();
    setState(() {});
  }

  downvote() async {
    User user = await User.fetchUser("HenriJSantos");
    QuerySnapshot upvotesSnapshot = await Question.getUpvoteCollection().where(
        "question", isEqualTo: _question.reference).where(
        "user", isEqualTo: user.reference).getDocuments();
    if (upvotesSnapshot.documents.isEmpty) {
      upvoted = -1;
      _question.upvotes--;
      setState(() {});
      await Question.getUpvoteCollection().add({
        'question': _question.reference,
        'user': user.reference,
        'value': -1
      });
    } else {
      final WriteBatch batch = Firestore.instance.batch();
      batch.delete(upvotesSnapshot.documents[0].reference);
      await batch.commit();
      if (upvotesSnapshot.documents[0]['value'] == -1) {
        upvoted = 0;
        _question.upvotes++;
        setState(() {});
      } else {
        upvoted = -1;
        _question.upvotes-=2;
        setState(() {});
        await Question.getUpvoteCollection().add({
          'question': _question.reference,
          'user': user.reference,
          'value': -1
        });
      }
    }
    await _question.updateUpvotes();
    setState(() {});
  }

  checkIfUpvoted() async {
    User user = await User.fetchUser("HenriJSantos");
    QuerySnapshot upvotesSnapshot = await Question.getUpvoteCollection().where(
        "question", isEqualTo: _question.reference).where(
        "user", isEqualTo: user.reference).getDocuments();
    if(upvotesSnapshot.documents.isEmpty)
      upvoted=0;
    else
      upvoted=upvotesSnapshot.documents[0]['value'];
    setState(() {});
  }
}