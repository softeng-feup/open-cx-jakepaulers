import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class TapButton extends When1WithWorld<String, FlutterWorld> {
  TapButton() : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  Future<void> executeStep(String key) async {
    final locator = find.byValueKey(key);
    await FlutterDriverUtils.tap(world.driver, locator, timeout: timeout);
  }

  @override
  RegExp get pattern => RegExp(r"I tap the {string} button");
}