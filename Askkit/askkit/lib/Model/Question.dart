import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String username;
  String question;
  DocumentReference reference;

  Question(this.username, this.question);

  Question.fromSnapshot(DocumentSnapshot snapshot):
        username = snapshot.data['username'],
        question = snapshot.data['content'],
        reference = snapshot.reference;

  Map<String, dynamic> toMap() => {'username' : username, 'content': question};

  static void addToCollection(Question question) {
    getCollection().add(question.toMap());
  }

  static CollectionReference getCollection() => Firestore.instance.collection('questions');
}
