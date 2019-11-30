import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'acceptance_testing//hooks/hook_example.dart';
import 'acceptance_testing/steps/expect_page.dart';
import 'acceptance_testing/steps/signout.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test/acceptance_testing/features/**.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      FlutterDriverReporter() // include this reporter if running on a CI server as Flutter driver logs all output to stderr
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..hooks = [
      HookExample()
    ] // you can include "AttachScreenhotOnFailedStepHook()" to take a screenshot of each step failure and attach it to the world object
    ..stepDefinitions = [
      SignOut(),
      ExpectToBeInPage(),
    ]
    ..customStepParameterDefinitions = [

    ]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test/acceptance_testing/app.dart"
  // ..buildFlavor = "staging" // uncomment when using build flavor and check android/ios flavor setup see android file android\app\build.gradle
  // ..targetDeviceId = "all" // uncomment to run tests on all connected devices or set specific device target id
  // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
  // ..logFlutterProcessOutput = true // uncomment to see the output from the Flutter process
    ..exitAfterTestRun = false; // set to false if debugging to exit cleanly
  return GherkinRunner().execute(config);

}