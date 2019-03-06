import 'package:flutter/material.dart';

import 'package:recipes_app/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes App',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        buttonColor: Theme.of(context).primaryColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => LoginScreen(),
      },
    );
  }
}
