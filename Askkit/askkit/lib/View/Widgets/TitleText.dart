import 'package:flutter/material.dart';

import '../Theme.dart';

class TitleText extends StatelessWidget {
  EdgeInsets padding;
  EdgeInsets margin;
  String text;

  TitleText({this.text = "", this.margin, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: this.margin,
        padding: this.padding,
        child: Text(text, style: Theme.of(context).textTheme.title)
    );
  }

}

class SubtitleText extends StatelessWidget {
  EdgeInsets padding;
  EdgeInsets margin;
  String text;

  SubtitleText({this.text = "", this.margin, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: this.margin,
        padding: this.padding,
        child: Text(text, style: Theme.of(context).textTheme.subtitle)
    );
  }

}