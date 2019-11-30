import 'dart:io';

import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/Talk.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/AuthListener.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseController {
  Future<void> signIn(String username, String password, AuthListener listener);
  Future<void> signUp(String email, String username, String password, AuthListener listener);
  Future<void> signOut();
  Future<void> sendForgotPassword(String username);
  Future<bool> changeUsername(String newUsername);
  Future<bool> changeEmail(String newEmail);
  Future<void> changeImage(File image);
  Future<void> changePassword(String newPassword);
  Future<void> updateUserInfo(String bios, String displayName);

  Future<DocumentReference> addQuestion(Talk talk, String content);
  Future<DocumentReference> addAnswer(Question question, String content);
  Future<DocumentReference> addTalk(Talk talk);

  User getCurrentUser();
  bool isAdmin();

  Future<bool> isAlreadyLoggedIn();

  Future<List<Talk>> getTalks();
  Future<List<Answer>> getAnswers(Question question);
  Future<List<Answer>> getAnswersByUser(User user);
  Future<List<Question>> getQuestions(Talk talk);
  Future<List<Question>> getQuestionsByUser(User user);
  Future<void> refreshQuestion(Question question);

  Future<User> getUserByUsername(String username);
  Future<User> getUserByEmail(String email);



  Future<void> setUserUpvote(DocumentReference question, int value);
  Future<int> getUserUpvote(DocumentReference question);
  Future<int> getUpvotes(Question question);

  Future<void> editQuestion(Question question, String newQuestion);
  Future<void> deleteQuestion(Question question);

  Future<void> editAnswer(Answer answer, String newAnswer);
  Future<void> deleteAnswer(Answer answer);

  Future<void> flagQuestionAsAnswered(Question question);
  Future<void> flagAnswerAsBest(Answer answer, bool isBest);






}