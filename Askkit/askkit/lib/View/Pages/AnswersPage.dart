import 'dart:math';

import 'package:askkit/Model/UserInput.dart';
import 'package:askkit/View/Widgets/UserInputCard.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';

class QuestionPage extends StatefulWidget {
  final UserInput _question;

  QuestionPage(this._question);

  @override
  State<StatefulWidget> createState() {
    return QuestionPageState();
  }

}

class QuestionPageState extends State<QuestionPage> {
  final List<UserInput> comments = new List();

  final int COMMENT_MAX_LEN = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Question Page"),
            backgroundColor: Colors.indigo[400]
        ),
        body: getBody(),
        floatingActionButton: RaisedButton(child: Icon(Icons.add), onPressed: addComment, color: gray)
    );
  }

  Widget getBody() {
    return Stack(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(top: 100.0),
              child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: UserInputCard(comments[i], false)
                    );
                  }
              )
          ),
          Positioned(
              child: UserInputCard(widget._question, false)
          )
        ]
    );
  }

  void addComment() {
    final TextEditingController commentController = TextEditingController();
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
                      controller: commentController,
                      decoration: new InputDecoration(
                        hintText: "Comment",
                        labelText: "Enter your comment",
                      ),
                      validator: (String value) {
                        if(value.length == 0)
                          return 'Comment can\'t be empty';
                        else return value.length > COMMENT_MAX_LEN ? 'Comment too big ($COMMENT_MAX_LEN characters max)' : null;
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
                          comments.add(UserInput("MOAAS", commentController.text));
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