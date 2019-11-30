import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class ExpectToBeInPage extends Given1WithWorld<String, FlutterWorld> {
  ExpectToBeInPage() : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  RegExp get pattern => RegExp(r"I expect to be in {string}");

  @override
  Future<void> executeStep(String name) async {
    bool isInPage = await FlutterDriverUtils.isPresent(find.byType(name), world.driver);
    expectMatch(isInPage, true);
  }
}