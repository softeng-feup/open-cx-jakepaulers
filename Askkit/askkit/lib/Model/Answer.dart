import 'package:askkit/Model/Comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Answer extends Comment {
  DocumentReference question;
  DocumentReference reference;

  Answer(String username, String answer, DocumentReference question): this.question = question,
        super(username, answer);

  Answer.fromSnapshot(DocumentSnapshot snapshot):
        question = snapshot.data['question'],
        reference = snapshot.reference,
        super(snapshot.data['username'], snapshot.data['content']);

  Map<String, dynamic> toMap() =>
      {'username': username, 'content': content, 'question': question};

  static void addToCollection(Answer answer) {
    getCollection().add(answer.toMap());
  }

  static CollectionReference getCollection() =>
      Firestore.instance.collection('answers');
}
