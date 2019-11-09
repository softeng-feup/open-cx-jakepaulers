import 'package:askkit/View/Controllers/AuthListener.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'Authenticator.dart';

class FirebaseController implements DatabaseController {
  static final Firestore firebase =  Firestore.instance;

  @override
  Future<void> addAnswer(Answer answer) {
    firebase.collection("answers").add({'username': answer.user.username, 'content': answer.content, 'question': answer.question});
  }

  @override
  Future<void> addQuestion(Question question) {
    firebase.collection("questions").add({'username': question.user.username, 'content': question.content});
  }

  @override
  Future<void> addUser(User user) {
    firebase.collection("users").add({'username' : user.username, 'email' : user.email, 'name': user.name, 'image' : user.image});
  }

  Future<Question> _makeQuestion(DocumentSnapshot document) async {
    User user = await this.getUser(document.data['username']);
    String content = document.data['content'];
    Question question = Question(user, content, document.reference);
    question.upvotes = await this.getUpvotes(question);
    question.userVote = await this.getUserUpvote(question, user);
    return question;
  }

  @override
  Future<Question> refreshQuestion(Question question) async {
    return await _makeQuestion(await question.reference.get());
  }

  @override
  Future<List<Question>> getQuestions() async {
    List<Question> questions = new List();
    QuerySnapshot questionSnapshot = await firebase.collection("questions").getDocuments();
    for (DocumentSnapshot document in questionSnapshot.documents) {
      questions.add(await _makeQuestion(document));
    }
    return questions;
  }

  @override
  Future<List<Answer>> getAnswers(Question question) async {
    List<Answer> answers = new List();
    QuerySnapshot questionSnapshot = await firebase.collection("answers").where("question", isEqualTo: question.reference).getDocuments();
    for (DocumentSnapshot document in questionSnapshot.documents) {
      User user = await this.getUser(document.data['username']);
      DocumentReference question = document.data['question'];
      String content = document.data['content'];
      answers.add(Answer(user, content, question, document.reference));
    }
    return answers;
  }

  @override
  Future<User> getUser(String username) async {
    QuerySnapshot snapshot = await firebase.collection("users").where("username", isEqualTo: username).limit(1).getDocuments();
    if (snapshot.documents.length == 0)
      return NullUser();
    Map data = snapshot.documents[0].data;
    return User(data['username'], data['email'], data['name'], data['image'], snapshot.documents[0].reference);
  }

  @override
  Future<User> getUserByEmail(String email) async {
    QuerySnapshot snapshot = await firebase.collection("users").where("email", isEqualTo: email).limit(1).getDocuments();
    if (snapshot.documents.length == 0)
      return NullUser();
    Map data = snapshot.documents[0].data;
    return User(data['username'], data['email'], data['name'], data['image'], snapshot.documents[0].reference);
  }

  @override
  Future<User> getCurrentUser() async {
    FirebaseUser user = await Auth.getCurrentUser();
    if (user == null)
      return NullUser();
    return await getUserByEmail(user.email);
  }

  Future<DocumentSnapshot> _getUserVote(Question question, User user) async {
    QuerySnapshot queryRes = await firebase.collection("upvotes").where("question", isEqualTo: question.reference).where("user", isEqualTo: user.reference).limit(1).getDocuments();
    if (queryRes.documents.length == 0)
      return null;
    return queryRes.documents[0];
  }

  @override
  Future<void> setVote(Question question, User user, int value) async {
    Map<String, dynamic> newData = {
      'question': question.reference,
      'user': user.reference,
      'value': value
    };
    DocumentSnapshot userVote = await _getUserVote(question, user);
    if (userVote == null)
      firebase.collection("upvotes").add(newData);
    else userVote.reference.updateData(newData);
  }

  @override
  Future<int> getUpvotes(Question question) async {
    int count = 0;
    QuerySnapshot upvotes = await firebase.collection("upvotes").where("question", isEqualTo: question.reference).getDocuments();
    for (DocumentSnapshot upvote in upvotes.documents) {
      count += upvote.data['value'];
    }
    return count;
  }

  @override
  Future<int> getUserUpvote(Question question, User user) async {
    DocumentSnapshot vote = await _getUserVote(question, user);
    if (vote == null)
      return 0;
    return vote.data['value'];
  }

  @override
  Future<void> signIn(String username, String password, AuthListener listener) async {
    try {
      if (username == "" || password == "")
        return listener.onSignInSuccess(null);
      User user = await getUser(username);
      if (user == null)
        return listener.onSignInIncorrect();
      await Auth.signIn(user.email, password);
      if (await Auth.isEmailVerified())
        listener.onSignInSuccess(await this.getUser(username));
      else listener.onSignInUnverified();
    }
    on PlatformException catch (exception) {
      print("ESXPEICOITN");
      print(exception.code);
      listener.onSignInIncorrect();

    }
  }

  @override
  Future<void> signUp(String email, String username, String password, AuthListener listener) async {
    try {
      await Auth.signUp(email,  password);
      await addUser(User(username, email, "", User.defaultAvatar, null));
      listener.onSignUpSuccess();
    }
    on PlatformException catch (exception) {
      listener.onSignUpDuplicate();
    }
  }

  @override
  Future<void> sendEmailVerification() {
    Auth.sendEmailVerification();
  }

  @override
  Future<void> signOut() {
    Auth.signOut();
  }



}