import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String _responseFromNativeCode = 'Waiting for Response...';
  Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              child: Text('Call Native Method'),
              onPressed: () async {
                await _runNativeLauncher();
              },
            ),
            Text(_responseFromNativeCode),
          ],
        ),
      ),
    );
  }

  void _launchMonitoring() {
    _timer = Timer.periodic(
        Duration(milliseconds: 900), (Timer t) => _getResults());
  }

  Future<void> _runNativeLauncher() async {
    try {
      await launcherPlatform.invokeMethod('launchClient');
      _launchMonitoring();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getResults() async {
    String response = "";
    try {
      final String result = await resultsPlatform.invokeMethod('getResults');
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    setState(() {
      _responseFromNativeCode = response;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
