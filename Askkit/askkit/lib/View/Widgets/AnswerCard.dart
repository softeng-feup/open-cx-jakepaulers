import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Comment.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:askkit/View/Pages/ManageCommentPage.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'CustomDialog.dart';

class AnswerCard extends CardTemplate {
  final Answer _answer;
  final DatabaseController _dbcontroller;

  AnswerCard(ModelListener listener, this._answer, this._dbcontroller) : super(listener);

  @override onClick(BuildContext context) {}

  @override
  Widget buildCardContent(BuildContext context) {
    bool enableActions = _dbcontroller.getCurrentUser().username == _answer.user.username;
    return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                  radius: 15.0,
                  backgroundImage: _answer.user.getImage()
              ),
              Text("  " + _answer.user.username, style: CardTemplate.usernameStyle),
              Spacer(),
              Visibility(visible: enableActions, child: IconButton(icon: Icon(Icons.edit), onPressed: () => editAnswer(context))),
              Visibility(visible: enableActions, child: IconButton(icon: Icon(Icons.delete), onPressed: () => deleteAnswer(context))),
              Text(_answer.getAgeString(), style: CardTemplate.dateStyle, textAlign: TextAlign.end),

            ],
          ),
          Container(
            padding: CardTemplate.contentPadding,
            child: Text(_answer.content, style: CardTemplate.contentStyle),
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
    this.listener.refreshModel();
  }

  void deleteAnswer(BuildContext context) async {
    ConfirmDialog(
        title: "Are you sure?",
        content: "This will delete your comment.",
        context: context,
        yesPressed: () async { await _dbcontroller.deleteAnswer(_answer); this.listener.refreshModel(); } ,
        noPressed: () {}
    ).show();
  }
}