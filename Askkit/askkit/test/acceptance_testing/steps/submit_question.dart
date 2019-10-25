import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class SubmitQuestion extends WhenWithWorld<FlutterWorld> {
  SubmitQuestion() : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  Future<void> executeStep() async {
    final username = find.byValueKey("username field");
    final question = find.byValueKey("question field");
    final submit = find.byValueKey("submit question");
    await FlutterDriverUtils.enterText(world.driver, username, "USERNAME");
    await FlutterDriverUtils.enterText(world.driver, question, "QUESTION");
    await FlutterDriverUtils.tap(world.driver, submit, timeout: timeout);
  }

  @override
  RegExp get pattern => RegExp(r"And I submit a question");
}