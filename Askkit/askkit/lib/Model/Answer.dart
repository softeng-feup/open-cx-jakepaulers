import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Answer extends Comment {
  DocumentReference question;
  DocumentReference reference;

  Answer(User user, String answer, DocumentReference question): this.question = question,
        super(user, answer);

  Answer.fromSnapshot(User user, DocumentSnapshot snapshot):
        question = snapshot.data['question'],
        reference = snapshot.reference,
        super(user, snapshot.data['content']);

  Map<String, dynamic> toMap() =>
      {'username': user.username, 'content': content, 'question': question};

  static void addToCollection(Answer answer) {
    getCollection().add(answer.toMap());
  }

  static CollectionReference getCollection() =>
      Firestore.instance.collection('answers');
}
