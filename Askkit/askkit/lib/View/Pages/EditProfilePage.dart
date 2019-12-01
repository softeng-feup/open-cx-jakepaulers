import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Widgets/CustomDialog.dart';
import 'package:askkit/View/Widgets/CustomTextForm.dart';
import 'package:askkit/View/Widgets/ShadowDecoration.dart';
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
        body: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: _user.getImage(), fit: BoxFit.cover,),
            ),
            child: Container(
                margin: EdgeInsets.all(30),
                decoration: ShadowDecoration(color: Theme.of(context).canvasColor, blurRadius: 5.0, spreadRadius: 1),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Stack(
                              children: <Widget>[
                                CircleAvatar(radius: 45.0, backgroundImage: _user.getImage()),
                                Positioned(
                                    bottom: 10.0,
                                    right: 10.0,
                                    child: GestureDetector(
                                        onTap: () {
                                          ImagePicker.pickImage(source: ImageSource.gallery).then((image) async {
                                            String url = await _dbcontroller.changeImage(image);
                                            setState((){_user.image = url;});
                                          });
                                        },
                                        child: Icon(Icons.edit, color: Colors.white)
                                    )
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(1.0),
                            decoration: new BoxDecoration(
                              color: Theme.of(context).iconTheme.color, // border color
                              shape: BoxShape.circle,
                            )
                        ),
                        Row(
                            children: <Widget>[
                              Text("Username: "),
                              Flexible(
                                child: TextAreaForm(usernameKey, usernameController , "Your username",  "Username can't be empty!")
                              )
                            ]
                        ),
                        Row(
                          children: <Widget>[
                            Text("Display Name: "),
                            Flexible(
                              child: TextAreaForm(nameKey, nameController , "Your display name",  "Display name can't be empty!")
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Bios: "),
                            Flexible(
                                child: TextAreaForm(biosKey, biosController , "Your bios",  "Bios can't be empty!")
                            )
                          ],
                        )
                      ],
                    )
                )
            )
        )
    );
  }

  void _onSubmitPressed(BuildContext context) async {
    if (!validateForm())
      return;

    if(_user.username != usernameController.text) {
      await _dbcontroller.changeUsername(usernameController.text);
      setState((){_user.username=usernameController.text;});
    }

    if(_user.name != nameController.text || _user.bios != biosController.text) {
      await _dbcontroller.updateUserInfo(biosController.text, nameController.text);
      setState((){_user.name=nameController.text; _user.bios = biosController.text;});
    }

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