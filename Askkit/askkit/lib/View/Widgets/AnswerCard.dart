import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Pages/AnswersPage.dart';
import 'package:askkit/View/Widgets/UserInputCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class AnswerCard extends UserInputCard {
  final Answer _answer;

  AnswerCard(this._answer);

  @override
  Comment getComment() {
    return _answer;
  }

  @override
  onClick(BuildContext context) {

  }
}