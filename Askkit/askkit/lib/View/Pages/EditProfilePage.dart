import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
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
  TextEditingController nameController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController biosController = new TextEditingController();

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
                    Container(
                        //child: Text(_user.username, style: Theme.of(context).textTheme.body2.copyWith(fontSize: 35)),
                        child: TextField(controller: nameController, style: Theme.of(context).textTheme.body2.copyWith(fontSize: 35), onEditingComplete: () async {
                          await _dbcontroller.changeUsername(usernameController.text);
                          _user.username = usernameController.text;
                          setState((){});
                        }),
                        margin: EdgeInsets.all(15)
                    ),
                    Row(
                      children: <Widget>[
                        Text("Also known as: "),
                        Flexible(
                            child: TextField(controller: nameController, onEditingComplete: () async {
                              await _dbcontroller.updateUserInfo(_user.bios, nameController.text);
                              _user.name = nameController.text;
                              setState((){});
                            })
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Flexible(
                        child: TextField(controller: biosController, onEditingComplete: () async {
                          await _dbcontroller.updateUserInfo(biosController.text, _user.name);
                          _user.bios = biosController.text;
                          setState((){});
                        })
                    )

                  ],
                )
              )
          )
        )
    );
  }
}