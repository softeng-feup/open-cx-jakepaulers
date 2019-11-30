import 'package:askkit/Model/Talk.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:askkit/View/Controllers/UrlLauncher.dart';
import 'package:askkit/View/Pages/QuestionsPage.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TalkCard extends CardTemplate {
  final Talk _talk;
  final DatabaseController _dbcontroller;

  TalkCard(ModelListener listener, this._talk, this._dbcontroller) : super(listener);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_talk.title, style: CardTemplate.usernameStyle(context, false)),
          Container(
            padding: CardTemplate.contentPadding,
            child: MarkdownBody(data: _talk.description, onTapLink: UrlLauncher.launchURL),
            alignment: Alignment.centerLeft,
          ),
          Divider(),
          Row(
              children: [
                Text("By " + _talk.host.name, style: CardTemplate.dateStyle(context)),
                Spacer(),
                Text(_talk.getStartDate() + ", Room " + _talk.room, style: CardTemplate.dateStyle(context)),
              ]
          )
        ]
    );
  }

  @override
  onClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionsPage(_talk, _dbcontroller)));
  }

  @override
  onHold(BuildContext context) { }

}