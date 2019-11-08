import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Answer extends Comment {
  DocumentReference question;
  DocumentReference reference;

  Answer(User user, String answer, DocumentReference question, DocumentReference reference): this.question = question,
        super(user, answer, reference);
}
