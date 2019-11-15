import 'dart:async';
import 'dart:math';

import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Pages/LogInPage.dart';
import 'package:askkit/View/Theme.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:askkit/View/Widgets/DynamicFAB.dart';
import 'package:askkit/View/Widgets/QuestionCard.dart';
import 'package:askkit/View/Widgets/TextAreaForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class QuestionsPage extends StatefulWidget {
  final DatabaseController _dbcontroller;
  final _talk;

  QuestionsPage(this._talk, this._dbcontroller);

  @override
  State<StatefulWidget> createState() {
    return QuestionsPageState();
  }

}

class QuestionsPageState extends State<QuestionsPage> {
  List<Question> questions = new List();

  bool loading = false;
  Timer minuteTimer;
  ScrollController scrollController;

  @override void initState() {
    scrollController = ScrollController();
    minuteTimer = Timer.periodic(Duration(minutes: 1), (t) { setState(() { }); });
    this.fetchQuestions();
  }

  @override void dispose() {
    minuteTimer.cancel();
    super.dispose();
  }

  void fetchQuestions() async {
    Stopwatch sw = Stopwatch()..start();
    setState(() { loading = true; });
    questions = await widget._dbcontroller.getQuestions(widget._talk);
    questions.sort((question1, question2) => question2.upvotes.compareTo(question1.upvotes));
    if (this.mounted)
      setState(() { loading = false; });
    print("Question fetch time: " + sw.elapsed.toString());

    if (scrollController.hasClients)
      scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Conference Page"),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: fetchQuestions),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: getBody(),
        floatingActionButton: DynamicFAB(scrollController, addQuestionForm)
    );
  }

  Widget getBody() {
    return Column(
        children: <Widget>[
          Visibility( visible: this.loading, child: CardTemplate.loadingIndicator(context)),
          Expanded(child: questionList())
        ]
    );
  }


  Widget questionList() {
    if (questions.length == 0 && !this.loading)
      return Center(child: Text("Feels lonely here 😔 \nBe the first to ask something!", textScaleFactor: 1.25, textAlign: TextAlign.center));
    return ListView.builder(
        controller: scrollController,
        itemCount: this.questions.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: CardTemplate.cardShadow,
                        blurRadius: 0.0,
                        spreadRadius: 1.0,
                        offset: Offset(0.0, 1.0)
                    ),
                  ]
              ),
              margin: EdgeInsets.only(top: 10.0),
              child: QuestionCard(this.questions[i], true, widget._dbcontroller)
          );
        }
    );
  }


  void addQuestionForm() {
    TextAreaForm textarea = TextAreaForm("Type a question", "Question can't be empty");
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
                          this.addQuestion(textarea.getText());
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

  void addQuestion(String text) async {
    User user = await widget._dbcontroller.getCurrentUser();
    await widget._dbcontroller.addQuestion(Question(widget._talk, user, text, DateTime.now(), null));
    fetchQuestions();
  }
}