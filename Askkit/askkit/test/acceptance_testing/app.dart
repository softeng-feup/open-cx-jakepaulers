
import 'package:askkit/Model/Answer.dart';
import 'package:askkit/Model/Question.dart';
import 'package:askkit/Model/Talk.dart';
import 'package:askkit/Model/User.dart';
import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Pages/LogInPage.dart';
import 'package:askkit/View/Pages/TalksPage.dart';
import 'package:askkit/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_driver/driver_extension.dart';

class TestDB extends Mock implements DatabaseController {

}

void main() async {
  // This line enables the extension
  enableFlutterDriverExtension();

  User testUser = User("Test", "m.m@gmail.com", "Name", User.defaultAvatar, "bios", null);
  Talk testTalk = Talk("Title", "Desc",DateTime.now(), testUser,  "Room", null);
  Question testQuestion = Question(null, testUser, "Question?", DateTime.now(), null);
  Answer testAnswer = Answer(testUser, "Answer!", DateTime.now(), null, null);

  bool signedin = true;

  DatabaseController controller = TestDB();
  when(controller.getCurrentUser()).thenReturn(testUser);
  when(controller.isAlreadyLoggedIn()).thenAnswer((_) => Future.value(signedin));
  when(controller.isAdmin()).thenReturn(true);
  when(controller.signOut()).thenAnswer((_) {signedin = false; });
  when(controller.getTalks()).thenAnswer((_) => Future.value([testTalk]));
  when(controller.getQuestions(testTalk)).thenAnswer((_) => Future.value([testQuestion]));
  when(controller.getAnswers(testQuestion)).thenAnswer((_) => Future.value([testAnswer]));

  // Call the `main()` function of your app or call `runApp` with any widget you
  // are interested in testing.
  runApp(MyApp(controller, Brightness.light));
}