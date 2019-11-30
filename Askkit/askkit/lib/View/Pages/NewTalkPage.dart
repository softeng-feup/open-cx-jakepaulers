import 'package:askkit/Model/Talk.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:askkit/View/Widgets/CustomTextForm.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class NewTalkPage extends StatelessWidget {
  static final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  static final GlobalKey<FormState> _formkey2 = GlobalKey<FormState>();
  static final GlobalKey<FormState> _formkey3 = GlobalKey<FormState>();
  static final GlobalKey<FormState> _formkey4 = GlobalKey<FormState>();
  static final GlobalKey<FormState> _formkey5 = GlobalKey<FormState>();
  static final TextEditingController _titleController = TextEditingController();
  static final TextEditingController _descController = TextEditingController();
  static final TextEditingController _roomController = TextEditingController();
  static final TextEditingController _usernameController = TextEditingController();
  static final TextEditingController _dateController = TextEditingController();

  DatabaseController dbcontroller;

  NewTalkPage(this.dbcontroller);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
          appBar: AppBar(
            title: Text("New talk"),
            actions: <Widget>[
              FlatButton(child: Text("Submit", style: Theme.of(context).textTheme.headline.copyWith(fontSize: 16)), onPressed: () => _onSubmitPressed(context))
            ],
          ),
          body: ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
                  child: CustomTextField(_formkey1, _titleController,"The theme of your talk",  "Talk title can't be empty!", autofocus: true)
              ),
              Divider(thickness: 1, height: 1),
              Container(
                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
                  child: CustomTextField(_formkey4, _usernameController, "Host username", "Username can't be empty!")
              ),
              Divider(thickness: 1, height: 1),
              Container(
                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
                  child: CustomTextField(_formkey3, _roomController, "Room location", "Room can't be empty!")
              ),
              Divider(thickness: 1, height: 1),
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
                child: CustomDateTimeField(_formkey5, _dateController)
              ),
              Divider(thickness: 1, height: 1),
              Container(
                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
                  constraints: BoxConstraints(minHeight: 200),
                  child: TextAreaForm(_formkey2, _descController, "A summary of what you'll discuss", "Talk description can't be empty!")
              ),
            ],
          )
      ),
    );
  }

  void _onSubmitPressed(BuildContext context) async {
    if (!validateForm())
      return;
    User host = await dbcontroller.getUserByUsername(_usernameController.text);
    if (host == null) {
      OkDialog("Talk could not be added", "Username does not exist.", context).show();
      return;
    }
    ConfirmDialog(
      context: context,
      title: "Add talk?",
      content: "This action cannot be reversed.",
      yesPressed: () {
        dbcontroller.addTalk(Talk(_titleController.text, _descController.text, DateTime.parse(_dateController.text), host, _roomController.text, null));
        [_usernameController, _roomController, _titleController, _descController].forEach((controller) => controller.clear());
        Navigator.pop(context);
      },
      noPressed: () {}
    ).show();
  }

  Future<bool> _onBackPressed(BuildContext context) {
    return CustomDialog(
      context: context,
      title: "Are you sure?",
      content: "This will discard your talk.",
      actions: <Widget>[
        FlatButton(child: Text("Cancel"), onPressed: () { Navigator.of(context).pop(false);}),
        FlatButton(child: Text("Discard"), onPressed: () { Navigator.of(context).pop(true); }),
      ],
    ).show() ?? false;
  }

  bool validateForm() {
    bool isValid = true;
    [_formkey1, _formkey2, _formkey3, _formkey4, _formkey5].forEach((key) {
      if (!key.currentState.validate())
        isValid = false;
    });
    return isValid;
  }
}