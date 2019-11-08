import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Pages/AnswersPage.dart';
import 'package:askkit/View/Widgets/UserInputCard.dart';
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

}