import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Answer extends Comment {
  DocumentReference question;

  Answer(User user, String answer, DateTime date, this.question, DocumentReference reference): super(user, answer, date, reference);
}
