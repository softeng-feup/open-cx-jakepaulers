import 'dart:ffi';
import 'dart:io';

import 'package:askkit/Model/Talk.dart';
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
    firebase.collection("answers").add({'username': answer.user.username, 'content': answer.content, 'uploadDate' : Timestamp.fromDate(answer.date), 'question': answer.question});
  }

  @override
  Future<void> addQuestion(Question question) {
    firebase.collection("questions").add({'talk': question.talk, 'username': question.user.username, 'content': question.content, 'uploadDate' : Timestamp.fromDate(question.date)});
  }

  @override
  Future<void> addUser(User user) {
    firebase.collection("users").add({'username' : user.username, 'email' : user.email, 'name': user.name, 'image' : user.image});
  }

  @override
  Future<void> addTalk(Talk talk) {
    firebase.collection("talks").add({'title' : talk.title, 'room' : talk.room, 'description': talk.description, 'host': talk.host.username});
  }

  Future<Question> _makeQuestionFromDoc(DocumentSnapshot document, Future<User> currentUser) async {
    User user = await this.getUser(document.data['username']);
    String content = document.data['content'];
    Timestamp date = document.data['uploadDate'];
    DocumentReference talk = document.data['talk'];
    Question question = Question(talk, user, content, date.toDate(), document.reference);
    question.upvotes = await this.getUpvotes(question);
    question.userVote = await this.getUserUpvote(question, await currentUser);
    question.numComments = await this._getNumAnswers(question);
    return question;
  }

  Future<Answer> _makeAnswerFromDoc(DocumentSnapshot document) async {
    User user = await this.getUser(document.data['username']);
    DocumentReference question = document.data['question'];
    String content = document.data['content'];
    Timestamp date = document.data['uploadDate'];
    return Answer(user, content, date.toDate(), question, document.reference);
  }

  Future<Talk> _makeTalkFromDoc(DocumentSnapshot document) async {
    User host = await this.getUser(document.data['host']);
    return Talk(document.data['title'], host, document.data['room'], document.data['description'], document.reference);
  }


  @override
  Future<List<Talk>> getTalks() async {
    List<Future<Talk>> talks = new List();
    QuerySnapshot snapshot = await firebase.collection("talks").getDocuments();
    for (DocumentSnapshot document in snapshot.documents) {
      talks.add(_makeTalkFromDoc(document));
    }
    if (snapshot.documents.length == 0)
      return [];
    return await Future.wait(talks);
  }


  @override
  Future<List<Question>> getQuestions(Talk talk) async {
    Future<User> currentUser = this.getCurrentUser();
    List<Future<Question>> questions = new List();
    QuerySnapshot snapshot = await firebase.collection("questions").where('talk', isEqualTo: talk.reference).getDocuments();
    for (DocumentSnapshot document in snapshot.documents) {
        questions.add(_makeQuestionFromDoc(document, currentUser));
    }
    if (snapshot.documents.length == 0)
      return [];
    return await Future.wait(questions);
  }

  @override
  Future<Question> refreshQuestion(Question question) async {
    return await _makeQuestionFromDoc(await question.reference.get(), this.getCurrentUser());
  }

  @override
  Future<List<Answer>> getAnswers(Question question) async {
    List<Future<Answer>> answers = new List();
    QuerySnapshot snapshot = await firebase.collection("answers").where("question", isEqualTo: question.reference).orderBy('uploadDate', descending: true).getDocuments();
    for (DocumentSnapshot document in snapshot.documents) {
      answers.add(_makeAnswerFromDoc(document));
    }
    if (snapshot.documents.length == 0)
      return [];
    return await Future.wait(answers);
  }

  Future<int> _getNumAnswers(Question question) async {
    QuerySnapshot answers = await firebase.collection("answers").where("question", isEqualTo: question.reference).getDocuments();
    return answers.documents.length;
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
    if (user.isNull())
      return null;
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
      print("Exception " + exception.code);
      listener.onSignInIncorrect();
    }
  }

  @override
  Future<void> signUp(String email, String username, String password, AuthListener listener) async {
    User user = await getUser(username);
    if (!user.isNull())
      return listener.onSignUpDuplicateUsername();
    try {
      await Auth.signUp(email,  password);
      await addUser(User(username, email, username, User.defaultAvatar, null));
      listener.onSignUpSuccess();
    }
    on PlatformException catch (exception) {
      print("Exception " + exception.code);
      listener.onSignUpDuplicateEmail();
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

  @override
  Future<void> sendForgotPassword(String username) async {
    User user = await this.getUser(username);
    if (user.isNull())
      return;
    try {
      Auth.sendForgotPassword(user.email);
    }
    catch (exception) {}
  }
}