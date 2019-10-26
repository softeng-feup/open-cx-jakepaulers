import 'package:askkit/Model/Comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question extends Comment {
  DocumentReference reference;

  Question(String username, String question) : super(username, question);

  Question.fromSnapshot(DocumentSnapshot snapshot):
        reference = snapshot.reference,
        super(snapshot.data['username'], snapshot.data['content']);


  Map<String, dynamic> toMap() => {'username': username, 'content': content};

  static void addToCollection(Question question) {
    getCollection().add(question.toMap());
  }

  static CollectionReference getCollection() =>
      Firestore.instance.collection('questions');
}
