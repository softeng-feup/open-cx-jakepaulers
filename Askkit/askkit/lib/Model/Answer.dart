import 'package:cloud_firestore/cloud_firestore.dart';

class Answer  {
  String username;
  String answer;
  DocumentReference question;
  DocumentReference reference;

  Answer(this.username, this.answer, this.question);

  Answer.fromSnapshot(DocumentSnapshot snapshot):
    username = snapshot.data['username'],
    answer = snapshot.data['content'],
    question = snapshot.data['question'],
    reference = snapshot.reference;

  Map<String, dynamic> toMap() =>  {'username' : username, 'content': answer, 'question' : question };

  static void addToCollection(Answer answer) {
    getCollection().add(answer.toMap());
  }

  static CollectionReference getCollection() => Firestore.instance.collection('answers');
}
