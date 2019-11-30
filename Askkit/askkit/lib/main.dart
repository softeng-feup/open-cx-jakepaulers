import 'package:askkit/View/Controllers/DatabaseController.dart';
import 'package:askkit/View/Controllers/Preferences.dart';
import 'package:askkit/View/Theme.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Controller/FirebaseController.dart';
import 'View/Pages/LogInPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await Preferences.getPreferences();
  Brightness brightness = (preferences.getBool("isDark") ?? false) ? Brightness.dark: Brightness.light;
  runApp(MyApp(FirebaseController(), brightness));
}

class MyApp extends StatelessWidget {
  final DatabaseController controller;
  final Brightness brightness;
  MyApp(this.controller, this.brightness);


  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: this.brightness,
        data: (brightness) {
          if (brightness == Brightness.light)
            return AskkitThemes.lightTheme();
          else return AskkitThemes.darkTheme();
        },
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'AskKit',
            theme: theme,
            home: LogInPage(controller),
          );
        }
    );
}
}

