import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/AuthListener.dart';

abstract class DatabaseController {
  Future<void> signIn(String username, String password, AuthListener listener);
  Future<void> signUp(String email, String username, String password, AuthListener listener);
  Future<void> signOut() {}
  Future<void> sendEmailVerification();
  Future<void> sendForgotPassword(String username);

  Future<void> addQuestion(Question question);
  Future<void> addAnswer(Answer answer);
  Future<void> addUser(User user);

  Future<User> getUser(String username);
  Future<User> getCurrentUser();
  Future<List<Answer>> getAnswers(Question question);
  Future<List<Question>> getQuestions();
  Future<Question> refreshQuestion(Question question);

  Future<int> getUserUpvote(Question question, User user);
  Future<int> getUpvotes(Question question);

  Future<void> setVote(Question question, User user, int value);



}