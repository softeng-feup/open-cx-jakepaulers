import 'package:flutter/material.dart';

import '../Theme.dart';

class TitleText extends StatelessWidget {
  EdgeInsets padding;
  EdgeInsets margin;
  String text;
  double fontSize;

  TitleText({this.fontSize = 10.0, this.text = "", this.margin, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: this.margin,
        padding: this.padding,
        child: Text(text, style: Theme
            .of(context)
            .textTheme
            .title
            .copyWith(fontSize: this.fontSize,
            fontWeight: FontWeight.bold,
            color: primaryColor),
        )
    );
  }

}