import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:askkit/View/Widgets/AnswerCard.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:askkit/View/Widgets/QuestionCard.dart';
import 'package:askkit/View/Widgets/ShadowDecoration.dart';
import 'package:askkit/View/Widgets/TitleText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatelessWidget {
  final DatabaseController _dbcontroller;
  final User _user;
  bool self;
  ProfilePage(this._user, this._dbcontroller) {
    this.self = (_user == this._dbcontroller.getCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title:  Text(_user.username + "'s Profile"),
          bottom: TabBar(
            isScrollable: false,
            tabs: [
              Tab(text: 'Info'),
              Tab(text: 'Questions'),
              Tab(text: 'Answers')
            ]
          )
        ),
        body: TabBarView(
          children: [
            createProfileTab(),
            createQuestionsTab(),
            createAnswersTab()
          ]
        )
      )
    );
  }

  Widget createProfileTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
            radius: 45.0,
            backgroundImage: _user.getImage()
        ),
        getUsernameLine(),
      ],
    );
  }

  Widget createQuestionsTab() {
    return QuestionsTab(this._user, this._dbcontroller);
  }

  createAnswersTab() {
    return AnswersTab(this._user, this._dbcontroller);
  }

  changeUsername() {
    print("Lmao, culpa o Moás");
  }

  Widget getUsernameLine() {
    return this.self?
    Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleText(text: _user.username, margin: EdgeInsets.only(top: 10.0)),
          GestureDetector(
              child: Icon(Icons.edit),
              onTap: () => changeUsername()
          )
        ]
    ) : TitleText(text: _user.username, margin: EdgeInsets.only(top: 10.0));
  }
}

class QuestionsTab extends StatefulWidget{
  User _user;
  DatabaseController _dbcontroller;

  QuestionsTab(this._user, this._dbcontroller);

  @override
  State<StatefulWidget> createState() {
    return QuestionsTabState(this._user, this._dbcontroller);
  }
}

class QuestionsTabState extends State<QuestionsTab> implements ModelListener {
  DatabaseController _dbcontroller;
  User _user;
  bool loading = true;
  List<Question> questions = new List();

  QuestionsTabState(this._user, this._dbcontroller) {
    this.refreshModel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Visibility(visible: this.loading, child: LinearProgressIndicator()),
          Expanded(child: questionList())
        ]
    );
  }

  questionList() {
    return ListView(
        children: questions.map((question) =>
            Container(
                decoration: ShadowDecoration(
                    shadowColor: CardTemplate.cardShadowColor,
                    spreadRadius: 1.0,
                    offset: Offset(0, 1)),
                margin: EdgeInsets.only(top: 10.0),
                child: QuestionCard(this, question, true, null, widget._dbcontroller))
        ).toList()
    );
  }

  @override
  Future refreshModel() async {
    Stopwatch sw = Stopwatch()..start();
    if (this.mounted)
      setState(() { loading = true; });
    questions = await this._dbcontroller.getQuestionsByUser(this._user);
    questions.sort((question1, question2) => question2.upvotes.compareTo(question1.upvotes));
    if (this.mounted)
      setState(() { loading = false; });
    print(questions.length);
    print("Question fetch time: " + sw.elapsed.toString());
  }
}

class AnswersTab extends StatefulWidget{
  User _user;
  DatabaseController _dbcontroller;

  AnswersTab(this._user, this._dbcontroller);

  @override
  State<StatefulWidget> createState() {
    return AnswersTabState(this._user, this._dbcontroller);
  }
}

class AnswersTabState extends State<AnswersTab> implements ModelListener {
  DatabaseController _dbcontroller;
  User _user;
  bool loading = true;
  List<Answer> answers = new List();

  AnswersTabState(this._user, this._dbcontroller) {
    this.refreshModel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Visibility(visible: this.loading, child: LinearProgressIndicator()),
          Expanded(child: answerList())
        ]
    );
  }

  answerList() {
    return ListView(
        children: answers.map((answer) =>
            Container(
                decoration: ShadowDecoration(
                    shadowColor: CardTemplate.cardShadowColor,
                    spreadRadius: 1.0,
                    offset: Offset(0, 1)),
                margin: EdgeInsets.only(top: 10.0),
                child: AnswerCard(this, answer, null, widget._dbcontroller))
        ).toList()
    );
  }

  @override
  Future refreshModel() async {
    Stopwatch sw = Stopwatch()..start();
    if (this.mounted)
      setState(() { loading = true; });
    answers = await this._dbcontroller.getAnswersByUser(this._user);
    if (this.mounted)
      setState(() { loading = false; });
    print("Question fetch time: " + sw.elapsed.toString());
  }
}