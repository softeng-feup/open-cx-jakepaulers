import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Widgets/CollectionListViewBuilder.dart';
import 'package:askkit/View/Widgets/QuestionCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';

class QuestionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QuestionsPageState();
  }

}

class QuestionsPageState extends State<QuestionsPage> {
  List<Question> questions = new List();
  bool loaded = false;

  final int USERNAME_MAX_LEN = 16;
  final int QUESTION_MAX_LEN = 64;

  @override
  void initState() {
    this.fetchQuestions();
  }

  void fetchQuestions() async {
    loaded = false;
    questions = new List();
    QuerySnapshot questionSnapshot = await Question.getCollection().getDocuments();
    for (DocumentSnapshot document in questionSnapshot.documents) {
      User user = await User.fetchUser(document.data['username']);
      questions.add(Question.fromSnapshot(user, document));
    }
    loaded = true;
    setState(() { });
  }

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
    if (!this.loaded)
      return LinearProgressIndicator();
    return ListView.builder(
        itemCount: this.questions.length,
        itemBuilder: (BuildContext context, int i) {
          return QuestionCard(this.questions[i], true);
        }
    );
    //return makeStreamBuilder(Question.getCollection(), (document) => QuestionCard(Question.fromSnapshot(document), true));
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
                        User.fetchUser(usernameController.text).then((user) {
                          Question.addToCollection(Question(user, questionController.text));
                          fetchQuestions();
                        });
                        Navigator.pop(context);
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