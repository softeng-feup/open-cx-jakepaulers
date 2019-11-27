import 'package:askkit/View/Controllers/ModelListener.dart';
import 'package:flutter/material.dart';

abstract class CardTemplate extends StatelessWidget {

  static const Color cardColor = Colors.white;

  static const Color cardShadowColor = Color.fromARGB(255, 180, 180, 180);

  static TextStyle usernameStyle(BuildContext context, bool highlight) {
    if (highlight)
      return Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold, fontSize: 20.0, color: Theme.of(context).primaryColor);
    return Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold, fontSize: 20.0);
  }

  static TextStyle dateStyle(BuildContext context) => Theme.of(context).textTheme.body1.copyWith(fontSize: 10.0);
  static TextStyle editedStyle(BuildContext context) => Theme.of(context).textTheme.body1.copyWith(fontSize: 8.0);

  static const EdgeInsets contentPadding = EdgeInsets.only(top: 10.0);

  final ModelListener listener;

  CardTemplate(this.listener);

  Widget buildCardContent(BuildContext context);

  onClick(BuildContext context);

  onHold(BuildContext context);

  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onLongPress: () => onHold(context),
        onTap: () => onClick(context),
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: buildCardContent(context)
        ),
      ),
      color: CardTemplate.cardColor,
    );
  }
}