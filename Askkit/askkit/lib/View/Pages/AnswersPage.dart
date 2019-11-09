import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Theme.dart';
import 'package:askkit/View/Theme.dart' as prefix0;
import 'package:askkit/View/Widgets/AnswerCard.dart';
import 'package:askkit/View/Widgets/Borders.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:askkit/View/Widgets/QuestionCard.dart';
import 'package:askkit/View/Widgets/TextAreaForm.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';

class AnswersPage extends StatefulWidget {
  Question _question;
  final DatabaseController _dbcontroller;

  AnswersPage(this._question, this._dbcontroller);

  @override
  State<StatefulWidget> createState() {
    return AnswersPageState();
  }

}

class AnswersPageState extends State<AnswersPage> {
  List<Answer> answers = new List();
  bool loaded = false;

  final int COMMENT_MAX_LEN = 80;


  @override
  void initState() {
    this.fetchAnswers();
  }

  void fetchAnswers() async {
    loaded = false;
    setState(() { });
    widget._question = await widget._dbcontroller.refreshQuestion(widget._question);
    answers = await widget._dbcontroller.getAnswers(widget._question);
    loaded = true;
    if (this.mounted)
      setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Question Page"),
            backgroundColor: primaryColor,
            actions: <Widget>[
              IconButton(icon: Icon(Icons.refresh), onPressed: fetchAnswers),
              IconButton(icon: Icon(Icons.edit), onPressed: addAnswerForm),
            ],
        ),
        backgroundColor: backgroundColor,
        body: getBody(),
    );
  }



  Widget getBody() {
    return Column(
        children: <Widget>[
          QuestionCard(widget._question, false, widget._dbcontroller),
          Divider(color: CardTemplate.cardShadow, thickness: 1.0, height: 1.0),
          !this.loaded ? CardTemplate.loadingIndicator() : Container(),
          Expanded(child: answerList(widget._question))
        ]
    );
  }

  Widget answerList(Question question) {
    if (answers.length == 0)
      return Container(
        padding: EdgeInsets.all(10),
         child: Text("No comments yet 😂😂😂", textScaleFactor: 1.5, )
      );
    return ListView.builder(
        itemCount: answers.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
              decoration: BoxDecoration(border: BorderLeft(primaryColor, 4.0)),
              child: Column(
                children: <Widget>[
                  AnswerCard(answers[i]),
                  Divider(color: CardTemplate.cardShadow, thickness: 1.0, height: 1.0),
                ],
              )
          );
        }
    );
  }

  void addAnswerForm() {
    TextAreaForm textarea = TextAreaForm("Type a comment", "Comment can't be empty");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                textarea,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: new Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: new Text("Submit"),
                      onPressed: () {
                        if (!textarea.validate())
                          return;
                        this.addAnswer(textarea.getText());
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  void addAnswer(String text) async {
    User user = await widget._dbcontroller.getCurrentUser();
    await widget._dbcontroller.addAnswer(Answer(user, text, widget._question.reference, null));
    await fetchAnswers();
  }
}
