import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ocpua_app/UI/Lines/lineList.dart';
import 'package:ocpua_app/UI/login.dart';
import 'package:ocpua_app/bloc/line/line_bloc.dart';
import 'package:ocpua_app/bloc/signals/bloc.dart';
import 'package:ocpua_app/resources/links.dart';
import 'package:ocpua_app/support/Fly/fly.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _getIt = GetIt.instance;

  @override
  void initState() {
    _getIt.registerSingleton<Fly<dynamic>>(Fly<dynamic>(gqLink));
    _getIt.registerSingleton<LineBloc>(LineBloc());
    _getIt.registerSingleton<SignalsBloc>(SignalsBloc());

    super.initState();
  }

  String gqLink = AppLinks.protocol + AppLinks.apiBaseLink + "/graphql";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => LineList(),
          '/signIn': (BuildContext context) => SignIn(),
          '/lineList': (BuildContext context) => LineList(),
        });
  }
}
