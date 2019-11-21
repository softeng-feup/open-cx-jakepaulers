import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/Talk.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/AuthListener.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseController {
  Future<void> signIn(String username, String password, AuthListener listener);
  Future<void> signUp(String email, String username, String password, AuthListener listener);
  Future<void> signOut() {}
  Future<void> sendEmailVerification();
  Future<void> sendForgotPassword(String username);

  Future<DocumentReference> addQuestion(Question question);
  Future<DocumentReference> addAnswer(Answer answer);
  Future<DocumentReference> addUser(User user);
  Future<DocumentReference> addTalk(Talk talk);
  
  Future<User> getUser(String username);

  User getCurrentUser();

  Future<List<Talk>> getTalks();
  Future<List<Answer>> getAnswers(Question question);
  Future<List<Question>> getQuestions(Talk talk);
  Future<List<Question>> getQuestionsByUser(User user);
  Future<Question> refreshQuestion(Question question);

  Future<int> getUserUpvote(Question question, User user);
  Future<int> getUpvotes(Question question);

  Future<void> setVote(Question question, User user, int value);

  Future<void> editQuestion(Question question, String newQuestion);
  Future<void> deleteQuestion(Question question);

  Future<void> editAnswer(Answer answer, String newAnswer);
  Future<void> deleteAnswer(Answer answer);





}