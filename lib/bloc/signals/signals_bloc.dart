import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ocpua_app/PODO/Signal.dart';
import 'package:ocpua_app/bloc/bloc.dart';
import 'package:ocpua_app/bloc/signals/bloc.dart';
import 'package:ocpua_app/bloc/signals/signals_state.dart';
import 'package:rxdart/rxdart.dart';

class SignalsBloc extends BLoC<SignalsEvent> {
  ///init as singleton
  static SignalsBloc _signalsBloc;

  static SignalsBloc instance() {
    if (_signalsBloc == null) {
      //print('CREATING NEW BLOC..');
      _signalsBloc = SignalsBloc._();
    }
    return _signalsBloc;
  }

  SignalsBloc._();

  static const launcherPlatform =
  const MethodChannel('flutter.native/launcher');
  static const resultsPlatform = const MethodChannel('flutter.native/results');
  Timer _timer;
  final _nodesList = List<dynamic>();
  final _signalsList = List<Signal>();
  bool isAppTerminated = true;
  AppState appState = AppState.NEW_INSTANCE;

  final signalsStateSubject = PublishSubject<SignalsState>();
  final chartStateSubject = PublishSubject<SignalsState>();

  @override
  void dispatch(SignalsEvent event) async {
    if (event is SignalsDataRequested) {
      await _runNativeLauncher();
    }

    if (event is ChartDataRequested) {

    }
  }

  void _launchMonitoring() {
    _timer = Timer.periodic(
      Duration(milliseconds: 1000),
          (Timer t) => _getResults(),
    );
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
    try {
      final result = await resultsPlatform.invokeMethod('getResults');
      if ((result as List).isNotEmpty) {
        _nodesList.clear();
        _nodesList.addAll(result);
        getSignalsList(_nodesList);
        print('NODES SIZE = ${_nodesList.length}');

        signalsStateSubject.add(SignalsDataAreFetched(_signalsList));
        chartStateSubject.add(SignalsDataAreFetched(_signalsList));
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void getSignalsList(List<dynamic> nodes) {
    _signalsList.clear();
    for (var node in nodes) {
      //_sensorsList.add(Signal("Ramp", node.toString()));
    }
  }

  void dispose() {
    signalsStateSubject.close();
    chartStateSubject.close();
  }
}

enum AppState {
  ACTIVE,
  NEW_INSTANCE
}