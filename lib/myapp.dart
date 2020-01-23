import 'package:flutter/material.dart';
import 'package:ocpua_app/UI/Lines/lineList.dart';
import 'package:ocpua_app/UI/login.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => SignIn(),
        '/signIn': (BuildContext context) => SignIn(),
        '/lineList':(BuildContext context) => LineList(),
      }
    );
  }
}