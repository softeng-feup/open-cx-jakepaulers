import 'dart:async';

import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/Talk.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:askkit/View/Pages/ManageCommentPage.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:askkit/View/Widgets/CenterText.dart';
import 'package:askkit/View/Widgets/CustomListView.dart';
import 'package:askkit/View/Widgets/DynamicFAB.dart';
import 'package:askkit/View/Widgets/QuestionCard.dart';
import 'package:askkit/View/Widgets/ShadowDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class QuestionsPage extends StatefulWidget {
  final DatabaseController _dbcontroller;
  final Talk _talk;

  QuestionsPage(this._talk, this._dbcontroller);

  @override
  State<StatefulWidget> createState() {
    return QuestionsPageState();
  }

}

class QuestionsPageState extends State<QuestionsPage> implements ModelListener {
  List<Question> questions = new List();

  bool loaded = false;
  Timer minuteTimer;
  ScrollController scrollController;

  @override void initState() {
    scrollController = ScrollController();
    minuteTimer = Timer.periodic(Duration(minutes: 1), (t) { setState(() { }); });
    this.refreshModel();
  }

  @override void dispose() {
    minuteTimer.cancel();
    super.dispose();
  }

  Future<void> refreshModel() async {
    Stopwatch sw = Stopwatch()..start();
    questions = await widget._dbcontroller.getQuestions(widget._talk);
    questions.sort((question1, question2) => question2.upvotes.compareTo(question1.upvotes));
    if (this.mounted)
      setState(() { loaded = true; });
    print("Question fetch time: " + sw.elapsed.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Questions"),
          backgroundColor: Theme.of(context).primaryColor
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: getBody(),
        floatingActionButton: DynamicFAB(scrollController, () => addQuestionForm(context))
    );
  }

  Widget getBody() {
    if (!this.loaded)
      return LinearProgressIndicator();
    return questionList();
  }


  Widget questionList() {
    if (questions.length == 0 && this.loaded)
      return _emptyQuestionList();
    return CustomListView(
        onRefresh: refreshModel,
        controller: scrollController,
        itemCount: this.questions.length + 1,
        itemBuilder: (BuildContext context, int i) {
          if (i == 0)
            return _talkHeader();
          return Container(
              decoration: ShadowDecoration(shadowColor: CardTemplate.cardShadowColor, spreadRadius: 1.0, offset: Offset(0, 1)),
              margin: EdgeInsets.only(top: 10.0),
              child: QuestionCard(this, this.questions[i - 1], true, widget._dbcontroller)
          );
        }
    );
  }

  void addQuestionForm(BuildContext context) async {
    Widget questionPage = NewQuestionPage(widget._talk);
    String comment = await Navigator.push(context, MaterialPageRoute(builder: (context) => questionPage));
    if (comment == null)
      return;
    DocumentReference reference = await widget._dbcontroller.addQuestion(widget._talk, comment);
    await widget._dbcontroller.setUserUpvote(reference, 1);

    refreshModel();
  }

  Widget _talkHeader() {
    return Container(
        decoration: ShadowDecoration(color: Theme.of(context).primaryColor, shadowColor: Colors.black, spreadRadius: 0.25, blurRadius: 7.5),
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      Text(widget._talk.host.name, style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 11), textAlign: TextAlign.left),
                      Spacer(),
                      Text("Room " + widget._talk.room, style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 11), textAlign: TextAlign.left)
                    ],
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(widget._talk.title, style: Theme.of(context).textTheme.headline.copyWith(height: 1.25), textAlign: TextAlign.center)
              ),
              Container(
                  child: Text(widget._talk.description, style: Theme.of(context).textTheme.subhead, textAlign: TextAlign.center)
              ),
            ]
        )
    );
  }

  Widget _emptyQuestionList() {
    return Column(
        children: <Widget>[
          _talkHeader(),
          Expanded(child: CenterText("Feels lonely here 😔\nBe the first to ask something!", textScale: 1.25))
        ]
    );
  }
}
