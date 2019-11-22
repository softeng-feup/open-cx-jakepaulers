import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          bottom: TabBar(
            isScrollable: false,
            tabs: [
              Tab(text: 'Info'),
              Tab(text: 'Posts')
            ]
          )
        ),
        body: TabBarView(
          children: [
            createProfileTab(),
            createPostsTab()
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

  Widget createPostsTab() {
    return PostsTab(this._user, this._dbcontroller);
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

class PostsTab extends StatefulWidget{
  User _user;
  DatabaseController _dbcontroller;

  PostsTab(this._user, this._dbcontroller);

  @override
  State<StatefulWidget> createState() {
    return PostsTabState(this._user, this._dbcontroller);
  }
}

class PostsTabState extends State<PostsTab> implements ModelListener {
  DatabaseController _dbcontroller;
  User _user;
  bool loading = false;
  List<Question> questions = new List();

  PostsTabState(this._user, this._dbcontroller) {
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
                child: QuestionCard(this, question, true, widget._dbcontroller))
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
    print("Question fetch time: " + sw.elapsed.toString());
  }
}