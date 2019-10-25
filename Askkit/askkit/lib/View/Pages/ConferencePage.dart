import 'package:askkit/Model/Question.dart';
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
  List<Question> questions;

  final int USERNAME_MAX_LEN = 16;
  final int QUESTION_MAX_LEN = 64;

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
      floatingActionButton: RaisedButton(key: const Key("add question"), child: Icon(Icons.add), onPressed: addQuestion, color: gray),
    );
  }

  Widget getBody() {
    return ListView.builder(
        key: const Key("question list"),
        itemCount: this.questions.length,
        itemBuilder: (BuildContext context, int i) {
          return QuestionCard(this.questions[i]);
        }
    );
  }

  void addQuestion() {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController questionController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: const Key("username field"),
                    controller: usernameController,
                    decoration: new InputDecoration(
                      hintText: "Username",
                      labelText: "Enter your username",
                    ),
                    validator: (String value) {
                      if(value.length == 0)
                        return 'Username can\'t be empty';
                      else return value.length > USERNAME_MAX_LEN ? 'Username too big ($USERNAME_MAX_LEN characters max)' : null;
                    }
                  ),
                  TextFormField(
                    key: const Key("question field"),
                    controller: questionController,
                    decoration: new InputDecoration(
                        hintText: "Question",
                        labelText: "Enter your question",
                    ),
                    validator: (String value) {
                      if(value.length == 0)
                        return 'Question can\'t be empty';
                      else return value.length > QUESTION_MAX_LEN ? 'Question too big ($QUESTION_MAX_LEN character max)' : null;
                    }
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      key: const Key("submit question"),
                      child: Text(
                          "Submit",
                          style: new TextStyle(
                            color: Colors.red
                          )
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        if(!_formKey.currentState.validate())
                          return;
                        questions.add(Question(usernameController.text, questionController.text));
                        Navigator.pop(context);
                        this.setState(() {});
                      },
                    )
                  )
                ],
              ),
            ),
          );
        });
  }
}