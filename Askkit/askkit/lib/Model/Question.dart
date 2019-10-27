import 'package:askkit/Model/Comment.dart';
import 'package:askkit/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question extends Comment {
  DocumentReference reference;

  Question(User user, String question) : super(user, question);

  Question.fromSnapshot(User user, DocumentSnapshot snapshot):
        reference = snapshot.reference,
        super(user, snapshot.data['content']);


  Map<String, dynamic> toMap() => {'username': user.username, 'content': content};

  static void addToCollection(Question question) {
    getCollection().add(question.toMap());
  }

  static CollectionReference getCollection() =>
      Firestore.instance.collection('questions');
}
