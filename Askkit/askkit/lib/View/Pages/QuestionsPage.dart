import 'package:askkit/Controller/FirebaseController.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Widgets/QuestionCard.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';

class QuestionsPage extends StatefulWidget {
  final DatabaseController _dbcontroller;

  QuestionsPage(this._dbcontroller);

  @override
  State<StatefulWidget> createState() {
    return QuestionsPageState();
  }

}

class QuestionsPageState extends State<QuestionsPage> {
  List<Question> questions = new List();
  bool loaded = false;

  final int QUESTION_MAX_LEN = 64;

  @override
  void initState() {
    this.fetchQuestions();
  }

  void fetchQuestions() async {
    loaded = false;
    questions = await FirebaseController().getQuestions();
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
      floatingActionButton: RaisedButton(child: Icon(Icons.add), onPressed: addQuestionForm, color: gray),
    );
  }

  Widget getBody() {
    if (!this.loaded)
      return LinearProgressIndicator();
    return ListView.builder(
        itemCount: this.questions.length,
        itemBuilder: (BuildContext context, int i) {
          return QuestionCard(this.questions[i], true, widget._dbcontroller);
        }
    );
  }

  void addQuestionForm() {
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
                        this.addQuestion(questionController.text);
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

  void addQuestion(String text) async {
    User user = await FirebaseController().getCurrentUser();
    await FirebaseController().addQuestion(Question(user, text, null));
    await fetchQuestions();
  }
}