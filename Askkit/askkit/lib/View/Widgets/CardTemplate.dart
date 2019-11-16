import 'package:flutter/material.dart';

abstract class CardTemplate extends StatelessWidget {
  static const Color cardColor = Colors.white;

  static const Color cardShadowColor = Color.fromARGB(255, 180, 180, 180);

  static const TextStyle contentStyle = TextStyle(color: Colors.black, fontSize: 15.0);
  static const TextStyle usernameStyle = TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold);
  static const TextStyle dateStyle = TextStyle(color: Colors.black, fontSize: 10.0);

  static const EdgeInsets outerPadding = EdgeInsets.all(10.0);
  static const EdgeInsets contentPadding = EdgeInsets.only(top: 10.0);

  Widget buildCardContent(BuildContext context);
  onClick(BuildContext context);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(context),
      child: new Container(
        padding: CardTemplate.outerPadding,
        color: CardTemplate.cardColor,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildCardContent(context)
          ],
        ),
      ),
    );
  }
}