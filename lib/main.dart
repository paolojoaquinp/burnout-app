import 'package:burnout/src/pages/edit_page.dart';
import 'package:burnout/src/pages/home_page.dart';
import 'package:burnout/src/pages/list_results_page.dart';
import 'package:burnout/src/pages/question_page.dart';
import 'package:burnout/src/pages/result_page.dart';
import 'package:burnout/src/pages/resume_page.dart';
import 'package:burnout/src/pages/splash_set_name.dart';
import 'package:burnout/src/pages/test_page.dart';
import 'package:burnout/src/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = new UserPreferences();
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: prefs.deafultRoute,
      routes: {
        'home' : (BuildContext context) => HomePage(),
        'question' : (BuildContext context) => QuestionPage(),
        'edit' : (BuildContext context) => EditPage(),
        'resume': (BuildContext context) => ResumePage(),
        'result': (BuildContext context) => ResultPage(),
        'list-results': (BuildContext context) => ListResultsPage(),
        'on-boarding': (BuildContext context) => SetNamePage()
      },
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
} 