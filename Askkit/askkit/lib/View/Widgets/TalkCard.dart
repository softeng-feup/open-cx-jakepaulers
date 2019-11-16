import 'package:askkit/Model/Talk.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Pages/QuestionsPage.dart';
import 'package:askkit/View/Widgets/CardTemplate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class TalkCard extends CardTemplate {
  final Talk _talk;
  final DatabaseController _dbcontroller;

  TalkCard(this._talk, this._dbcontroller);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_talk.title, style: CardTemplate.usernameStyle),
          Container(
            padding: CardTemplate.contentPadding,
            child: Text(_talk.description, style: CardTemplate.contentStyle),
            alignment: Alignment.centerLeft,
          ),
          Divider(),
          Row(
              children: [
                Text("By " + _talk.host.name, style: CardTemplate.dateStyle),
                Spacer(),
                Text(_talk.getStartDate() + ", Room " + _talk.room, style: CardTemplate.dateStyle),
              ]
          )
        ]
    );
  }

  @override
  onClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionsPage(_talk, _dbcontroller)));
  }

}