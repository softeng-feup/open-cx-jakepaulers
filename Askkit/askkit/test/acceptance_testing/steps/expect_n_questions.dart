import 'package:flutter/material.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_test/flutter_test.dart' as fl_test;
import 'package:gherkin/gherkin.dart' as gherkin;

class ExpectNQuestions extends gherkin.Given1<int> {
  ExpectNQuestions() : super(gherkin.StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  RegExp get pattern => RegExp(r"I expect the number of questions to be {int}");

  @override
  Future<void> executeStep(int numQuestions) {
    // TODO: implement executeStep
    //  final SerializableFinder locator = find.byValueKey("question list");

   //fl_test.Finder a = fl_test.find.byKey(Key("question list"));
  //  WidgetsFlutterBinding.ensureInitialized().attachRootWidget("AAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
    //if (WidgetsBinding.instance == null)
   //   print("WAS NULL AAAAAAAAAAAA");
    //else print("LALALALALAALALAL");
    //if (WidgetsBinding.instance == null)
    //  print("STILL NULLSANHLAKLASHSLKAHLK");

     //  print(a.evaluate());

    //for (Element element in a) {
    //  ListView lss = element.widget;
    //  print("Hello everyone" + lss.semanticChildCount.toString());
    //  expectMatch(lss.semanticChildCount, numQuestions);
    //  break;
    //}

  }
}