import 'dart:ui';

import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:askkit/View/Pages/EditPages/EditProfilePage.dart';
import 'package:askkit/View/Widgets/AnswerCard.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:askkit/View/Widgets/CustomListView.dart';
import 'package:askkit/View/Widgets/QuestionCard.dart';
import 'package:askkit/View/Widgets/ShadowDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  final DatabaseController _dbcontroller;
  final User _user;
  final bool self;

  ProfilePage(this._user, this._dbcontroller) : this.self = (_user == _dbcontroller.getCurrentUser());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            title:  Text(_user.username + "'s Profile"),
            bottom: TabBar(
                isScrollable: false,
                tabs: [
                  Tab(text: 'Info'),
                  Tab(text: 'Questions'),
                  Tab(text: 'Answers')
                ]
            ),
            actions: <Widget>[
              Visibility(visible: self, child: IconButton(icon: Icon(Icons.edit), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(this._user, this._dbcontroller))))),
            ],
          ),
          body: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: _user.getImage(), fit: BoxFit.cover),
              ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: TabBarView(
                children: [
                  createProfileTab(context),
                  createQuestionsTab(context),
                  createAnswersTab(context)
                ],
              ),
            ),

          ),
        )
    );
  }

  Widget createProfileTab(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(50),
        decoration: ShadowDecoration(color: Theme.of(context).canvasColor, blurRadius: 5.0, spreadRadius: 1),
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    child: new CircleAvatar(radius: 60.0, backgroundImage: _user.getImage()),
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.all(1.0),
                    decoration: new BoxDecoration(
                      color: Theme.of(context).iconTheme.color, // border color
                      shape: BoxShape.circle,
                    )
                ),
                Container(
                    child: Text(_user.username, style: Theme.of(context).textTheme.body2.copyWith(fontSize: 35)),
                    margin: EdgeInsets.all(15)
                ),
                Text("Also known as: " + _user.name),
                Divider(thickness: 1, height: 15, indent: 15, endIndent: 15),
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                    child: MarkdownBody(data: _user.bios)
                )
          ],
        )
    ));
  }

  Widget createQuestionsTab(BuildContext context) {
    return QuestionsTab(this._user, this._dbcontroller);
  }

  Widget createAnswersTab(BuildContext context) {
    return AnswersTab(this._user, this._dbcontroller);
  }

  Future editProfile(BuildContext context) {
    print("ta aqi para testar");

    ImagePicker.pickImage(source: ImageSource.gallery).then((image) async {
      await _dbcontroller.changeImage(image);
    });
  }
}

class QuestionsTab extends StatefulWidget{
  final User _user;
  final DatabaseController _dbcontroller;

  QuestionsTab(this._user, this._dbcontroller);

  @override
  State<StatefulWidget> createState() {
    return QuestionsTabState();
  }
}

class QuestionsTabState extends State<QuestionsTab> with AutomaticKeepAliveClientMixin<QuestionsTab>  implements ModelListener {
  bool showLoadingIndicator = false;
  List<Question> questions = new List();
  ScrollController scrollController;


  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    this.refreshModel(true);
  }

  @override bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Visibility(visible: this.showLoadingIndicator, child: LinearProgressIndicator()),
          Expanded(child: questionList())
        ]
    );
  }

  questionList() {
    return CustomListView(
      onRefresh: () => refreshModel(false),
      controller: scrollController,
      itemCount: this.questions.length,
      itemBuilder: (BuildContext context, int i) {
        return Container(
            decoration: ShadowDecoration(shadowColor: Colors.black.withAlpha(150), spreadRadius: 1.0, offset: Offset(0, 1)),
            margin: EdgeInsets.only(top: 10.0),
            child: QuestionCard(this, questions[i], true, null, widget._dbcontroller)
        );
      },
    );
  }

  @override
  Future refreshModel(bool showIndicator) async {
    Stopwatch sw = Stopwatch()..start();
    setState(() { showLoadingIndicator = showIndicator; });
    questions = await widget._dbcontroller.getQuestionsByUser(widget._user);
    questions.sort((question1, question2) => question2.upvotes.compareTo(question1.upvotes));
    if (this.mounted)
      setState(() { showLoadingIndicator = false; });
    print("Question fetch time: " + sw.elapsed.toString());
  }
}

class AnswersTab extends StatefulWidget{
  final User _user;
  final DatabaseController _dbcontroller;

  AnswersTab(this._user, this._dbcontroller);

  @override
  State<StatefulWidget> createState() {
    return AnswersTabState();
  }
}

class AnswersTabState extends State<AnswersTab> with AutomaticKeepAliveClientMixin<AnswersTab>  implements ModelListener {
  bool showLoadingIndicator = false;
  List<Answer> answers = new List();
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    this.refreshModel(true);
  }

  @override bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Visibility(visible: this.showLoadingIndicator, child: LinearProgressIndicator()),
          Expanded(child: answerList())
        ]
    );
  }

  answerList() {
    return CustomListView(
        onRefresh: () => refreshModel(false),
        controller: scrollController,
        itemCount: this.answers.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
              decoration: ShadowDecoration(shadowColor: Colors.black.withAlpha(150), spreadRadius: 1.0, offset: Offset(0, 1)),
              margin: EdgeInsets.only(top: 10.0),
              child: AnswerCard(this, answers[i], null, widget._dbcontroller)
          );
        }
    );
  }

  @override
  Future refreshModel(bool showIndicator) async {
    Stopwatch sw = Stopwatch()..start();
    setState(() { showLoadingIndicator = showIndicator; });
    answers = await widget._dbcontroller.getAnswersByUser(widget._user);
    if (this.mounted)
      setState(() { showLoadingIndicator = false; });
    print("Question fetch time: " + sw.elapsed.toString());
  }

}