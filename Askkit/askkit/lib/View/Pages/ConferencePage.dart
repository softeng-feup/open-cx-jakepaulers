import 'package:askkit/View/Widgets/QuestionCard.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';

class ConferencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConferencePageState();
  }

}

class ConferencePageState extends State<ConferencePage> {
  List<Widget> questions;

  @override
  void initState() {
    questions = new List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Conference Page"),
          backgroundColor: Colors.red
      ),
      body: getBody(),
      floatingActionButton: RaisedButton(child: Icon(Icons.add), onPressed: addQuestion, color: gray),
    );
  }

  Widget getBody() {
    return ListView.builder(
        itemCount: this.questions.length,
        itemBuilder: (BuildContext context, int i) {
          return this.questions[i];
        }
    );
  }

  void addQuestion() {
    this.questions.add(QuestionCard());
    this.setState(() => this.questions = questions);
  }
}