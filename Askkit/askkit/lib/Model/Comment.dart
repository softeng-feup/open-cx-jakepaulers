import 'package:askkit/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Comment {
  User user;
  String content;

  Comment(this.user, this.content);
}