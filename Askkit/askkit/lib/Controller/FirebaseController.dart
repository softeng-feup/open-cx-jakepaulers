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
  static User _currentUser;
  static List<String> adminList = List();
  
  FirebaseController() {
    firebase.collection("admins").getDocuments().then((documents)  {
      documents.documents.forEach((document) async {
        String userRef = document.documentID;
        adminList.add((await firebase.collection("users").document(userRef).get())['username']);
      });
    });
  }

  @override
  Future<DocumentReference> addAnswer(Question question, String content) {
    assert (_currentUser != null);
    return firebase.collection("answers").add({'question': question.reference, 'user': _currentUser.reference, 'content': content, 'edited': false, 'bestanswer': false, 'uploadDate' : Timestamp.fromDate(DateTime.now()), });
  }

  @override
  Future<DocumentReference> addQuestion(Talk talk, String content) {
    assert (_currentUser != null);
    return firebase.collection("questions").add({'talk': talk.reference, 'user': _currentUser.reference, 'content': content, 'edited': false, 'answered' : false, 'uploadDate' : Timestamp.fromDate(DateTime.now())});
  }

  Future<DocumentReference> addUser(User user) {
    return firebase.collection("users").add({'username' : user.username, 'email' : user.email, 'name': user.name, 'image' : user.image});
  }

  @override
  Future<DocumentReference> addTalk(Talk talk) {
    return firebase.collection("talks").add({'title' : talk.title, 'room' : talk.room, 'description': talk.description, 'host': talk.host.reference, 'startDate' : talk.startDate});
  }

  Future<User> _makeUserFromDoc(DocumentSnapshot document) async {
    Map data = document.data;
    if (data == null)
      return User.empty();
    return User(data['username'], data['email'], data['name'], data['image'], document.reference);
  }

  Future<Question> _makeQuestionFromDoc(DocumentSnapshot document) async {
    DocumentReference userRef = document.data['user'];
    User user = await _makeUserFromDoc(await userRef.get());
    String content = document.data['content'];
    Timestamp date = document.data['uploadDate'];
    DocumentReference talk = document.data['talk'];
    Question question = Question(talk, user, content, date.toDate(), document.reference);
    question.upvotes = await this.getUpvotes(question);
    question.userVote = await this.getUserUpvote(question.reference);
    question.numComments = await this._getNumAnswers(question);
    if (document.data['edited'])
      question.setEdited();
    if (document.data['answered'])
      question.markAnswered();
    return question;
  }

  Future<Answer> _makeAnswerFromDoc(DocumentSnapshot document) async {
    DocumentReference userRef = document.data['user'];
    User user = await _makeUserFromDoc(await userRef.get());
    DocumentReference question = document.data['question'];
    String content = document.data['content'];
    Timestamp date = document.data['uploadDate'];
    Answer answer =  Answer(user, content, date.toDate(), question, document.reference);
    if (document.data['edited'])
      answer.setEdited();
    if (document.data['bestanswer'])
      answer.markAsBest(true);
    return answer;
  }

  Future<Talk> _makeTalkFromDoc(DocumentSnapshot document) async {
    DocumentReference userRef = document.data['host'];
    User host = await _makeUserFromDoc(await userRef.get());
    Timestamp date = document.data['startDate'];
    return Talk(document.data['title'], document.data['description'], date.toDate(), host, document.data['room'],  document.reference);
  }


  @override
  Future<List<Talk>> getTalks() async {
    List<Future<Talk>> talks = new List();
    QuerySnapshot snapshot = await firebase.collection("talks").orderBy('startDate').getDocuments();
    for (DocumentSnapshot document in snapshot.documents) {
      talks.add(_makeTalkFromDoc(document));
    }
    if (snapshot.documents.length == 0)
      return []; // firebase rebenta sem isto
    return await Future.wait(talks);
  }


  @override
  Future<List<Question>> getQuestions(Talk talk) async {
    List<Future<Question>> questions = new List();
    QuerySnapshot snapshot = await firebase.collection("questions").where('talk', isEqualTo: talk.reference).getDocuments();
    for (DocumentSnapshot document in snapshot.documents) {
        questions.add(_makeQuestionFromDoc(document));
    }
    if (snapshot.documents.length == 0)
      return [];
    return await Future.wait(questions);
  }

  Future<List<Question>> getQuestionsByUser(User user) async {
    List<Future<Question>> questions = new List();
    QuerySnapshot snapshot = await firebase.collection("questions").where('user', isEqualTo: user.reference).getDocuments();
    for (DocumentSnapshot document in snapshot.documents) {
      questions.add(_makeQuestionFromDoc(document));
    }
    if (snapshot.documents.length == 0)
      return [];
    return await Future.wait(questions);
  }


  @override
  Future<void> refreshQuestion(Question question) async {
    Question refreshedQuestion = await _makeQuestionFromDoc(await question.reference.get());
    question.copyFrom(refreshedQuestion);
  }

  @override
  Future<List<Answer>> getAnswers(Question question) async {
    List<Future<Answer>> answers = new List();
    QuerySnapshot snapshot = await firebase.collection("answers").where("question", isEqualTo: question.reference).orderBy('bestanswer', descending: true).orderBy('uploadDate').getDocuments();
    for (DocumentSnapshot document in snapshot.documents) {
      answers.add(_makeAnswerFromDoc(document));
    }
    if (snapshot.documents.length == 0)
      return [];
    return await Future.wait(answers);
  }

  @override
  Future<List<Answer>> getAnswersByUser(User user) async {
    List<Future<Answer>> answers = new List();
    QuerySnapshot snapshot = await firebase.collection("answers").where("user", isEqualTo: user.reference).orderBy('uploadDate', descending: true).getDocuments();
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
  Future<User> getUserByUsername(String username) async {
    QuerySnapshot snapshot = await firebase.collection("users").where("username", isEqualTo: username).limit(1).getDocuments();
    if (snapshot.documents.length == 0)
      return null;
    return await _makeUserFromDoc(snapshot.documents[0]);
  }

  @override
  Future<User> getUserByEmail(String email) async {
    QuerySnapshot snapshot = await firebase.collection("users").where("email", isEqualTo: email).limit(1).getDocuments();
    if (snapshot.documents.length == 0)
      return null;
    Map data = snapshot.documents[0].data;
    return User(data['username'], data['email'], data['name'], data['image'], snapshot.documents[0].reference);
  }

  Future<bool> isAlreadyLoggedIn() async {
    FirebaseUser user = await Auth.getCurrentUser();
    if (user == null)
      return false;
    _currentUser = await getUserByEmail(user.email);
    if (_currentUser == null)
      Auth.signOut();
    return _currentUser != null;
  }

  @override
  User getCurrentUser() {
    return _currentUser;
  }
  
  bool isAdmin() {
    return adminList.contains(_currentUser.username);
  }

  Future<DocumentSnapshot> _getUserUpvoteDoc(DocumentReference question) async {
    QuerySnapshot queryRes = await firebase.collection("upvotes").where("question", isEqualTo: question).where("user", isEqualTo: _currentUser.reference).limit(1).getDocuments();
    if (queryRes.documents.length == 0)
      return null;
    return queryRes.documents[0];
  }

  @override
  Future<void> setUserUpvote(DocumentReference question, int value) async {
    assert (_currentUser != null);
    Map<String, dynamic> newData = {
      'question': question,
      'user': _currentUser.reference,
      'value': value
    };
    DocumentSnapshot userVote = await _getUserUpvoteDoc(question);
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
  Future<int> getUserUpvote(DocumentReference question) async {
    DocumentSnapshot vote = await _getUserUpvoteDoc(question);
    if (vote == null)
      return 0;
    return vote.data['value'];
  }

  @override
  Future<void> signIn(String username, String password, AuthListener listener) async {
    try {
      User user = await getUserByUsername(username);
      if (user == null)
        return listener.onSignInIncorrect();
      await Auth.signIn(user.email, password);
      _currentUser = await this.getUserByUsername(username);
      listener.onSignInSuccess(_currentUser);
    }
    on PlatformException catch (exception) {
      print("Exception " + exception.code);
      listener.onSignInIncorrect();
    }
  }

  @override
  Future<void> signUp(String email, String username, String password, AuthListener listener) async {
    User user = await getUserByUsername(username);
    if (user != null)
      return listener.onSignUpDuplicateUsername();
    try {
      await Auth.signUp(email,  password);
      await addUser(User(username, email, username, User.defaultAvatar, null));
      await Auth.signIn(email, password);
      _currentUser = await this.getUserByUsername(username);
      listener.onSignUpSuccess();
    }
    on PlatformException catch (exception) {
      print("Exception " + exception.code);
      listener.onSignUpDuplicateEmail();
    }
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    return await Auth.signOut();
  }

  @override
  Future<void> sendForgotPassword(String username) async {
    User user = await this.getUserByUsername(username);
    if (user == null)
      return;
    try {
      Auth.sendForgotPassword(user.email);
    }
    catch (exception) {}
  }

  @override
  Future<void> deleteAnswer(Answer answer) async {
    await answer.reference.delete();
  }

  Future<void> _deleteAnswers(Question question) async {
    List<Answer> answers = await this.getAnswers(question);
    for (Answer answer in answers)
      answer.reference.delete();
  }

  @override
  Future<void> deleteQuestion(Question question) async {
    await Future.wait([question.reference.delete(),  _deleteAnswers(question)]);
  }

  @override
  Future<void> editAnswer(Answer answer, String newAnswer) async {
    await answer.reference.updateData({'content' : newAnswer, 'edited' : true});
  }

  @override
  Future<void> editQuestion(Question question, String newQuestion) async {
    await question.reference.updateData({'content' : newQuestion, 'edited' : true});
  }

  @override
  Future<void> flagQuestionAsAnswered(Question question) async {
    await question.reference.updateData({'answered' : true});
  }

  @override
  Future<void> flagAnswerAsBest(Answer answer, bool isBest) async {
    await answer.reference.updateData({'bestanswer' : isBest});
  }
}