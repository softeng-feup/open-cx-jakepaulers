import 'dart:math';

import 'package:askkit/Model/Talk.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:askkit/View/Widgets/ShadowDecoration.dart';
import 'package:askkit/View/Widgets/TalkCard.dart';
import 'package:flutter/material.dart';

class TalkSearchDelegate extends SearchDelegate<Talk> implements ModelListener {
  static final int maxSuggestions = 4;

  final DatabaseController dbcontroller;
  List<Talk> allTalks;

  TalkSearchDelegate(this.dbcontroller) : super(searchFieldLabel: "Search talk...") {
    dbcontroller.getTalks().then((talks) {
      allTalks = talks;
    });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = ThemeData();
    assert(theme != null);
    return theme.copyWith(
        primaryColor: Theme.of(context).canvasColor,
        primaryIconTheme: Theme.of(context).iconTheme,
        primaryColorBrightness: Brightness.light,
        primaryTextTheme: theme.textTheme,
        textTheme: TextTheme(title: TextStyle(fontSize: 20.0, color: Theme.of(context).primaryColor))
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        tooltip: 'Back',
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (allTalks == null)
      return LinearProgressIndicator();
    if (query.isEmpty)
      return Container();
    return talkList(allTalks.where((talk) => match(talk, query)).toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (allTalks == null)
      return LinearProgressIndicator();
    List<Talk>  suggestions;
    if (query.isEmpty)
      suggestions = allTalks;
    else suggestions = allTalks.where((talk) => match(talk, query)).toList();
    return stringList(suggestions.sublist(0, min(suggestions.length, maxSuggestions)).map((suggestion) => suggestion.title).toList(), context);
  }

  Widget stringList(List<String> strings, BuildContext context) {
    if (strings.isEmpty)
      return Container();
    return Container(
        decoration: ShadowDecoration(color: Theme.of(context).canvasColor, blurRadius: 2.0, spreadRadius: 1.0),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: strings.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                onTap: () {
                  showResults(context);
                  query = strings[i];
                },
                title: Text(strings[i], style: TextStyle(color: Colors.black),),
              );
            }
        )
    //  height: 100,
     // decoration: ShadowDecoration(color: Theme.of(context).canvasColor, blurRadius: 5.0, spreadRadius: 5.0, offset: Offset(0, 1)),
    );
  }

  Widget talkList(List<Talk> talks) {
    if (talks.isEmpty)
      return Container();
    return ListView.builder(
        itemCount: talks.length,
        itemBuilder: (BuildContext context, int i) {
          return Column(
            children: <Widget>[
              TalkCard(this, talks[i], this.dbcontroller),
              Divider(height: 1, thickness: 1,),
            ],
          );
        }
    );
  }

  @override
  void refreshModel() { }

  bool match(Talk talk, String query) {
    return talk.room.toLowerCase().contains(query.toLowerCase()) || talk.title.toLowerCase().contains(query.toLowerCase());
  }
}