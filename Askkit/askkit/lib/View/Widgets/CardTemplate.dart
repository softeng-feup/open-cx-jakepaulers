import 'package:askkit/View/Theme.dart';
import 'package:flutter/material.dart';

abstract class CardTemplate extends StatefulWidget {
  static const Color cardColor = Colors.white;

  static const Color cardMargin = Color.fromARGB(255, 235, 235, 235);
  static const Color cardShadow = Color.fromARGB(255, 180, 180, 180);

  static const TextStyle contentStyle = TextStyle(color: Colors.black, fontSize: 15.0);
  static const TextStyle usernameStyle = TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold);
  static const TextStyle loadingStyle = TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold);

  static const double borderRadius = 10.0;
  static const EdgeInsets outerPadding = EdgeInsets.all(10.0);
  static const EdgeInsets contentPadding = EdgeInsets.only(top: 10.0);


  State<StatefulWidget> createState() {
    return new CardTemplateState();
  }

  static Widget loadingIndicator() {
    return Column(
      children: <Widget>[
        LinearProgressIndicator(backgroundColor: cardMargin),
      //  Text("\nLoading...", textAlign: TextAlign.center, style: loadingStyle)
      ],
    ); LinearProgressIndicator();
  }

  Widget buildCardContent(BuildContext context);
  onClick(BuildContext context);
}

class CardTemplateState extends State<CardTemplate> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onClick(context),
      child: new Container(
        padding: CardTemplate.outerPadding,
        color: CardTemplate.cardColor,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.buildCardContent(context)
          ],
        ),
      ),
    );
  }


  @override
  Widget buildnotused(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onClick(context),
        child: Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Color.fromARGB(0, 0, 0, 0),
            elevation: 0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(CardTemplate.borderRadius)),
            child: new Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                        color: Color.fromARGB(0x0c, 0, 0, 0),
                        blurRadius: 7.0,
                        offset: Offset(0.0, 1.0))
                  ],
                  color: Theme
                      .of(context)
                      .accentColor,
                  borderRadius:
                  BorderRadius.all(Radius.circular(CardTemplate.borderRadius))),
              child: new ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 60.0,
                ),
                child: new Container(
                  decoration: BoxDecoration(
                      color: CardTemplate.cardColor,
                      borderRadius:
                      BorderRadius.all(Radius.circular(CardTemplate.borderRadius))),
                  width: (double.infinity),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: CardTemplate.outerPadding,
                        child: widget.buildCardContent(context),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

}