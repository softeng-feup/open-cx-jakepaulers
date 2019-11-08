import 'package:askkit/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Comment {
  User user;
  String content;
  DocumentReference reference;

  Comment(this.user, this.content, this.reference);
}