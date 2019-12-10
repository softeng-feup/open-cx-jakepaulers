import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Pages/EditPages/ChangeEmailPage.dart';
import 'package:askkit/View/Pages/EditPages/ChangePasswordPage.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:askkit/View/Widgets/CustomTextForm.dart';
import 'package:askkit/View/Widgets/ShadowDecoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final User _user;
  final DatabaseController _dbcontroller;

  EditProfilePage(this._user, this._dbcontroller);

  @override
  State<StatefulWidget> createState() => EditProfilePageState(this._user, this._dbcontroller);
}

class EditProfilePageState extends State<EditProfilePage> {
  final User _user;
  final DatabaseController _dbcontroller;
  bool loading = false;

  static TextEditingController nameController = new TextEditingController();
  static TextEditingController usernameController = new TextEditingController();
  static TextEditingController biosController = new TextEditingController();

  static final GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> usernameKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> biosKey = GlobalKey<FormState>();

  EditProfilePageState(this._user, this._dbcontroller);

  @override
  void initState() {
    nameController.text = this._user.name;
    usernameController.text = this._user.username;
    biosController.text = this._user.bios;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text(_user.username + "'s Profile"),
          actions: <Widget>[
            FlatButton(child: Icon(Icons.save, color: Colors.white), onPressed: () => _onSubmitPressed(context))
          ],
        ),
        body: ListView(
          children: <Widget>[
            Visibility(visible: loading, child: LinearProgressIndicator()),
            Container(
                child: _getEditableAvatar(),
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(1.0),
                decoration: new BoxDecoration(
                  color: Theme.of(context).iconTheme.color, // border color
                  shape: BoxShape.circle,
                )
            ),
        ..._makeEditable("Edit username:", CustomTextField(usernameKey, usernameController , "Your username",  "Username can't be empty!")),
        ..._makeEditable("Edit display name:", CustomTextField(nameKey, nameController , "Your display name",  "Display name can't be empty!")),
        ..._makeEditable("Edit bios:", TextAreaForm(biosKey, biosController , "Your bios",  "Bios can't be empty!"), maxFormHeight: 150),
            Container (
              padding: EdgeInsets.only(left: 20.0,right: 20.0),
    child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage(this._dbcontroller))),
                child: Text("Change Password", textAlign: TextAlign.center, style: Theme.of(context).textTheme.body2)
            ),
            SizedBox(height: 25),
            GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmailPage(this._dbcontroller))),
                child: Text("Change Email", textAlign: TextAlign.center, style: Theme.of(context).textTheme.body2)
            )
  ]
            )
            )
          ],
        )
    );
  }

  List<Widget> _makeEditable(String text, Widget formField, {double maxFormHeight = double.infinity}) {
    return  [
      Container(
        margin: EdgeInsets.only(left: 10.0),
        child: Text(text, style: Theme.of(context).textTheme.body1.copyWith(decoration: TextDecoration.underline)),
      ),
      Container(
        //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          constraints: BoxConstraints(maxHeight: maxFormHeight),
          margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
          child: formField
      )
    ];
  }

  Widget _getEditableAvatar() {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            CircleAvatar(radius: 60.0, backgroundImage: _user.getImage()),
            Positioned(
                bottom: 25.0,
                right: 25.0,
                child: GestureDetector(
                    onTap: pickUserImage,
                    child: Icon(Icons.edit, color: Colors.white, size: 25.0)
                )
            )
          ],
        )
      ],
    );
  }

  void pickUserImage() {
    ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600).then((image) async {
      if (image == null)
        return;
      setState((){this.loading=true;});
      String url = await _dbcontroller.changeImage(image);
      setState((){ _user.image = url; this.loading=false; });
    });
  }
  void _onSubmitPressed(BuildContext context) async {
    if (!validateForm())
      return;

    FocusScope.of(context).requestFocus(FocusNode());

    if(_user.username != usernameController.text) {
      await _dbcontroller.changeUsername(usernameController.text);
      _user.username=usernameController.text;;
    }

    if(_user.name != nameController.text || _user.bios != biosController.text) {
      await _dbcontroller.updateUserInfo(biosController.text, nameController.text);
      _user.name=nameController.text; _user.bios = biosController.text;;
    }

    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop(context);
  }

  bool validateForm() {
    bool isValid = true;
    [nameKey, usernameKey, biosKey].forEach((key) {
      if (!key.currentState.validate())
        isValid = false;
    });
    return isValid;
  }

}