import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:askkit/View/Controllers/UrlLauncher.dart';
import 'package:askkit/View/Pages/ManageCommentPage.dart';
import 'package:askkit/View/Pages/ProfilePage.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:askkit/View/Widgets/CustomPopupMenu.dart';
import 'package:askkit/View/Widgets/UserAvatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'CustomDialog.dart';

class AnswerCard extends CardTemplate {
  final User _questionPoster;
  final Answer _answer;
  final DatabaseController _dbcontroller;

  AnswerCard(ModelListener listener, this._answer, this._questionPoster, this._dbcontroller) : super(listener);

  @override onClick(BuildContext context) {}

  @override
  onHold(BuildContext context) {
    User currentUser = _dbcontroller.getCurrentUser();
    List<Widget> items = [];
    List<VoidCallback> actions = [];
    if (currentUser != _answer.user && currentUser != _questionPoster && !_dbcontroller.isAdmin())
      return;
    if (currentUser == _questionPoster || _dbcontroller.isAdmin()) {
      String verb = _answer.bestAnswer ? 'Unmark' : 'Mark';
      IconData icon =  _answer.bestAnswer ? Icons.star_border : Icons.star;
      items.add(Row(children: <Widget>[Icon(icon), Text('  $verb as best', style: Theme.of(context).textTheme.body1)]));
      actions.add(() => markBestAnswer(context));
    }
    if (currentUser == _answer.user || _dbcontroller.isAdmin()) {
      items.add(Row(children: <Widget>[Icon(Icons.edit), Text('  Edit', style: Theme.of(context).textTheme.body1)]));
      items.add(Row(children: <Widget>[Icon(Icons.delete), Text('  Delete', style: Theme.of(context).textTheme.body1)]));
      actions.add(() => editAnswer(context));
      actions.add(() => deleteAnswer(context));
    }
    CustomPopupMenu.show(context, items: items, actions: actions);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
        children: <Widget>[
          Visibility(
            visible: this._answer.bestAnswer,
            child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(bottom: 7.5),
                child: Row(children: <Widget>[
                  Icon(Icons.star, size: 16, color: Colors.yellow.shade800),
                  Text(" Best answer", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.yellow.shade800)),
                ])
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(this._answer.user, this._dbcontroller))),
                  child: UserAvatar(_answer.user,
                      avatarRadius: 15.0,
                      textStyle: CardTemplate.usernameStyle(context, _answer.user == _dbcontroller.getCurrentUser())
                  )
              ),

              Spacer(),
              Text(_answer.getAgeString() , style: CardTemplate.dateStyle(context)),
              Text(_answer.edited ? " (edited)" : "", style: CardTemplate.editedStyle(context).copyWith(fontStyle: FontStyle.italic)),
            ],
          ),
          Container(
            padding: CardTemplate.contentPadding,
            child: MarkdownBody(data: _answer.content, onTapLink: UrlLauncher.launchURL),
            alignment: Alignment.centerLeft,
          ),
        ]
    );
  }

  void editAnswer(BuildContext context) async {
    Widget editPage = EditAnswerPage(this._answer);
    String comment = await Navigator.push(context, MaterialPageRoute(builder: (context) => editPage));
    if (comment == null)
      return;
    this._dbcontroller.editAnswer(this._answer, comment);
    this._answer.content = comment;
    this.listener.refreshModel(true);
  }

  void deleteAnswer(BuildContext context) async {
    ConfirmDialog(
        title: "Are you sure?",
        content: "This will delete your comment.",
        context: context,
        yesPressed: () async {
          await this._dbcontroller.deleteAnswer(_answer);
          this.listener.refreshModel(true);
        } ,
        noPressed: () {}
    ).show();
  }

  void markBestAnswer(BuildContext context) async {
    this._answer.bestAnswer = !this._answer.bestAnswer;
    this._dbcontroller.flagAnswerAsBest(_answer, _answer.bestAnswer);
    this.listener.refreshModel(true);
  }
}