import 'package:askkit/View/Controllers/AuthListener.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'Authenticator.dart';

class FirebaseController implements DatabaseController {
  static final Firestore firebase =  Firestore.instance;

  static final String defaultAvatar = "https://images.pexels.com/photos/67636/rose-blue-flower-rose-blooms-67636.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";

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

  @override
  Future<List<Question>> getQuestions() async {
    List<Question> questions = new List();
    QuerySnapshot questionSnapshot = await firebase.collection("questions").getDocuments();
    for (DocumentSnapshot document in questionSnapshot.documents) {
      User user = await this.getUser(document.data['username']);
      String content = document.data['content'];
      questions.add(Question(user, content, document.reference));
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
      return null;
    Map data = snapshot.documents[0].data;
    return User(data['username'], data['email'], data['name'], data['image'], snapshot.documents[0].reference);
  }

  @override
  Future<User> getUserByEmail(String email) async {
    QuerySnapshot snapshot = await firebase.collection("users").where("email", isEqualTo: email).limit(1).getDocuments();
    if (snapshot.documents.length == 0)
      return null;
    Map data = snapshot.documents[0].data;
    return User(data['username'], data['email'], data['name'], data['image'], snapshot.documents[0].reference);
  }

  Future<User> getCurrentUser() async {
    FirebaseUser user = await Auth.getCurrentUser();
    return await getUserByEmail(user.email);
  }


  @override
  Future<void> downvote(Question question, User user) {
    // TODO: implement downvote
  }


  @override
  Future<void> upvote(Question question, User user) {
    // TODO: implement upvote
  }

  @override
  Future<int> getUpvotes(Question question) {
    // TODO: implement getUpvotes
    return null;
  }

  @override
  Future<int> getUserUpvote(String user) {
    // TODO: implement getUserUpvote
    return null;
  }

  @override
  Future<void> signIn(String username, String password, AuthListener listener) async {
    try {
      if (username == "" || password == "")
        return listener.onSignInSuccess(User("Anonymous", "", "Anon Ymous", defaultAvatar, null));
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
      await addUser(User(username, email, "", defaultAvatar, null));
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


}