import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Widgets/TitleText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Theme.dart';

class ProfilePage extends StatelessWidget {
  User _user;
  ProfilePage(this._user);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                  radius: 45.0,
                  backgroundImage: _user.getImage()
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TitleText(text: _user.username, fontSize: 38, margin: EdgeInsets.only(top: 10.0)),
                  GestureDetector(
                    child: Icon(Icons.edit),
                    onTap: () => print("Hello!")
                  )
                ]
              ),
            ],
          )
        )
    );
  }
}