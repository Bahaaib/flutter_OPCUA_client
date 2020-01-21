import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const launcherPlatform =
      const MethodChannel('flutter.native/launcher');
  static const resultsPlatform = const MethodChannel('flutter.native/results');
  Timer _timer;
  final _nodesList = List<dynamic>();
  bool _isLoading = false;

  @override
  void initState() {
    _nodesList.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Material(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text('Start Monitoring'),
                onPressed: () async {
                  await _runNativeLauncher();
                },
              ),
              Column(
                children: _nodesList
                    .map(
                      (node) => Text(node),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _launchMonitoring() {
    _timer =
        Timer.periodic(Duration(milliseconds: 1000), (Timer t) => _getResults());
  }

  Future<void> _runNativeLauncher() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await launcherPlatform.invokeMethod('launchClient');
      _launchMonitoring();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getResults() async {
    try {
      final result = await resultsPlatform.invokeMethod('getResults');
      if((result as List).isNotEmpty){
        setState(() {
          _isLoading = false;
          _nodesList.clear();
          _nodesList.addAll(result);
        });
      }

    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
