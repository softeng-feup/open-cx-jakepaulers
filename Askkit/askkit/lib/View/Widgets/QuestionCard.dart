import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme.dart';
import 'CardTemplate.dart';

class QuestionCard extends CardTemplate {
  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget> [
            CircleAvatar(
              backgroundColor: lightGray,
              backgroundImage: NetworkImage('https://noticias.up.pt//wp-content/uploads/2019/05/Pedro-Mo%C3%A1s-interior-e1556272376936.jpg'),
            ),
            Text(" "),
            Text("Pedro Miguel Moás")
          ],
        ),
        Container(
          child: Text("Pergunta", textScaleFactor: 1.3),
          alignment: Alignment.centerLeft,
        ),
      ]
    );
  }

  @override
  String getTitle() {
    return "Question :D";
  }

  @override
  onClick(BuildContext context) {
    return null;
  }

  @override
  Color getCardColor() {
    return lightGray;
  }
}