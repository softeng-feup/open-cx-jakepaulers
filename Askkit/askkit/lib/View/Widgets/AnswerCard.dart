import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Comment.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:askkit/View/Pages/ManageCommentPage.dart';
import 'package:askkit/View/Pages/ProfilePage.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:askkit/View/Widgets/CustomPopupMenu.dart';
import 'package:askkit/View/Widgets/UserAvatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'CustomDialog.dart';

class AnswerCard extends CardTemplate {
  final Answer _answer;
  final DatabaseController _dbcontroller;

  AnswerCard(ModelListener listener, this._answer, this._dbcontroller) : super(listener);

  @override onClick(BuildContext context) {}

  @override
  onHold(BuildContext context) {
    if ( _dbcontroller.getCurrentUser() != _answer.user)
      return;
    CustomPopupMenu.show(
        context,
        items: [
          Row(children: <Widget>[Icon(Icons.edit), Text('  Edit', style: Theme.of(context).textTheme.body1)]),
          Row(children: <Widget>[Icon(Icons.delete), Text('  Delete', style: Theme.of(context).textTheme.body1)]),
        ],
        actions: [
          () => editAnswer(context),
          () => deleteAnswer(context)
        ]);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
        children: <Widget>[
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
            child: MarkdownBody(data: _answer.content),
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
    this.listener.refreshModel();
  }

  void deleteAnswer(BuildContext context) async {
    ConfirmDialog(
        title: "Are you sure?",
        content: "This will delete your comment.",
        context: context,
        yesPressed: () async {
          await this._dbcontroller.deleteAnswer(_answer);
          this.listener.refreshModel();
        } ,
        noPressed: () {}
    ).show();
  }

}