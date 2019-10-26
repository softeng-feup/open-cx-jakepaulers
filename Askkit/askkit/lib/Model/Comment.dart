import 'package:askkit/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String username;
  String content;

  Comment(this.username, this.content);

  Comment.fromSnapshot(DocumentSnapshot snapshot):
        username = snapshot.data['username'],
        content = snapshot.data['content'];
}