import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/Talk.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:askkit/View/Widgets/TextAreaForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ManageCommentPage extends StatelessWidget {
  static final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  static final TextEditingController _controller = TextEditingController();

  final String title;
  final String hintText;
  final String emptyError;

  ManageCommentPage(this.hintText, this.emptyError, this.title);

  String getHeaderPrefix();
  String getHeaderSuffix();
  String initialContent();

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.body1;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.title),
          actions: <Widget>[
            FlatButton(child: Text("Submit", style: Theme.of(context).textTheme.subhead), onPressed: () => _onSubmitPressed(context))
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Text(this.getHeaderPrefix(), style: titleStyle),
                    Expanded(child: Text(this.getHeaderSuffix(), style: titleStyle.copyWith(color: Theme.of(context).primaryColor), overflow: TextOverflow.ellipsis))
                  ],
                )
            ),
            Divider(height: 1.0, thickness: 1.0),
            Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                constraints: BoxConstraints(minHeight: 200),
                child: TextAreaForm(_formkey, _controller, hintText, emptyError)
            )
          ],
        )
      ),
    );
  }

  void _onSubmitPressed(BuildContext context) {
    if (_controller.text == this.initialContent())
      Navigator.pop(context, null);
    else Navigator.pop(context, _controller.text);
  }

  Future<bool> _onBackPressed(BuildContext context) {
    if (_controller.text == this.initialContent())
      return Future<bool>.value(true);
    TextStyle buttonTheme = Theme.of(context).textTheme.subhead.copyWith(color: Colors.black);
    return CustomDialog(
          context: context,
          title: "Are you sure?",
          content: "This will discard your comment.",
          actions: <Widget>[
            FlatButton(child: Text("Cancel", style: buttonTheme), onPressed: () { Navigator.of(context).pop(false);}),
            FlatButton(child: Text("Discard", style: buttonTheme), onPressed: () { Navigator.of(context).pop(true); }),
          ],
    ).show() ?? false;
  }

  static void setControllerText(String text) {
    WidgetsBinding.instance.addPostFrameCallback((_) => ManageCommentPage._controller.text = text);
  }

}

class NewQuestionPage extends ManageCommentPage {
  final Talk talk;
  NewQuestionPage(this.talk) : super("Type question", "Question can't be empty", "New question") {
    ManageCommentPage.setControllerText("");
  }

  @override String getHeaderPrefix() => "Posting in: ";
  @override String getHeaderSuffix() => this.talk.title;
  @override String initialContent() => "";

}

class NewAnswerPage extends ManageCommentPage {
  final Question question;
  NewAnswerPage(this.question) : super("Type answer", "Answer can't be empty", "New answer") {
    ManageCommentPage.setControllerText("");
  }

  @override String getHeaderPrefix() => "Replying to: ";
  @override String getHeaderSuffix() => this.question.user.username;
  @override String initialContent() => "";
}

class EditQuestionPage extends ManageCommentPage {
  final Question question;
  EditQuestionPage(this.question) : super("Type question", "Question can't be empty", "New question") {
    ManageCommentPage.setControllerText(this.question.content);
  }

  @override String getHeaderPrefix() => "Editing question: ";
  @override String getHeaderSuffix() => this.question.content;
  @override String initialContent() => this.question.content;
}

class EditAnswerPage extends ManageCommentPage {
  final Answer answer;
  EditAnswerPage(this.answer) : super("Type answer", "Answer can't be empty", "New answer") {
    ManageCommentPage.setControllerText(this.answer.content);
  }

  @override String getHeaderPrefix() => "Editing reply: ";
  @override String getHeaderSuffix() => this.answer.content;
  @override String initialContent() => this.answer.content;
}