import 'package:askkit/Model/Question.dart';
import 'package:askkit/View/Widgets/CollectionListViewBuilder.dart';
import 'package:askkit/View/Widgets/UserInputCard.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';

class ConferencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConferencePageState();
  }

}

class ConferencePageState extends State<ConferencePage> {
 // List<Comment> questions;

  final int USERNAME_MAX_LEN = 16;
  final int QUESTION_MAX_LEN = 64;

  //@override
  //void initState() {
  //  questions = new List();
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Conference Page"),
          backgroundColor: Colors.indigo[400]
      ),
      body: getBody(),
      floatingActionButton: RaisedButton(child: Icon(Icons.add), onPressed: addQuestion, color: gray),
    );
  }

  Widget getBody() {
    return makeStreamBuilder(Question.getCollection(), (document) => UserInputCard(Question.fromSnapshot(document), true));
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
                        Question.addToCollection(Question(usernameController.text, questionController.text));
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