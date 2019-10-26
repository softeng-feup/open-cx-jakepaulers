import 'package:flutter/material.dart';

abstract class CardTemplate extends StatefulWidget {
  State<StatefulWidget> createState() {
    return new CardTemplateState();
  }

  Widget buildCardContent(BuildContext context);
  onClick(BuildContext context);
  Color getCardColor();
}

class CardTemplateState extends State<CardTemplate> {
  final double borderRadius = 10.0;
  final double padding = 10.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onClick(context),
        child: Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Color.fromARGB(0, 0, 0, 0),
            elevation: 0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(this.borderRadius)),
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
                  BorderRadius.all(Radius.circular(this.borderRadius))),
              child: new ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 60.0,
                ),
                child: new Container(
                  decoration: BoxDecoration(
                      color: this.widget.getCardColor(),
                      borderRadius:
                      BorderRadius.all(Radius.circular(this.borderRadius))),
                  width: (double.infinity),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: this.padding,
                            right: this.padding,
                            bottom: this.padding,
                            top: this.padding),
                        child: widget.buildCardContent(context),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}