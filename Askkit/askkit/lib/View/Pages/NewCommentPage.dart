import 'package:askkit/View/Widgets/TextAreaForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewCommentPage extends StatelessWidget {
  final TextAreaForm textarea;
  final String title;
  final String location;

  NewCommentPage(this.title, this.location, this.textarea);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            FlatButton(child: Text("Submit", style: Theme.of(context).textTheme.subhead), onPressed: () => _onSubmitPressed(context))
          ],
        ),
        body: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.body1;
    return ListView(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Text("Post in: ", style: titleStyle),
                Expanded(
                  child:
                Text(this.location,
                    style: titleStyle.copyWith(color: Theme.of(context).primaryColor),
                    overflow: TextOverflow.ellipsis)
                )
              ],
            )
        ),
        Divider(height: 1.0, thickness: 1.0),
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          constraints: BoxConstraints(minHeight: 200),
          child: textarea,
        )
      ],
    );
  }

  void _onSubmitPressed(BuildContext context) {
    if (textarea.validate())
      Navigator.pop(context, textarea.getText());
  }

  Future<bool> _onBackPressed(BuildContext context) {
    TextStyle buttonTheme = Theme.of(context).textTheme.subhead.copyWith(color: Colors.black);
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          titleTextStyle: Theme.of(context).textTheme.body2,
          contentTextStyle: Theme.of(context).textTheme.body1,
          title: Text("Are you sure?"),
          content: Text("This will discard your comment."),
          actions: <Widget>[
            FlatButton(child: Text("Cancel", style: buttonTheme), onPressed: () { Navigator.of(context).pop(false); }),
            FlatButton(child: Text("Discard", style: buttonTheme), onPressed: () { Navigator.of(context).pop(true); }),
          ],
        )
    ) ?? false;
  }
}
