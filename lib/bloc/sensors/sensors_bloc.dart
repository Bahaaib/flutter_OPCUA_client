import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ocpua_app/PODO/Sensor.dart';
import 'package:ocpua_app/bloc/bloc.dart';
import 'package:ocpua_app/bloc/sensors/bloc.dart';
import 'package:rxdart/rxdart.dart';

class SensorsBloc extends BLoC<SensorsEvent> {
  ///init as singleton
  static SensorsBloc _sensorsBloc;

  static SensorsBloc instance() {
    if (_sensorsBloc == null) {
      //print('CREATING NEW BLOC..');
      _sensorsBloc = SensorsBloc._();
    }
    return _sensorsBloc;
  }

  SensorsBloc._();

  static const launcherPlatform =
  const MethodChannel('flutter.native/launcher');
  static const resultsPlatform = const MethodChannel('flutter.native/results');
  Timer _timer;
  final _nodesList = List<dynamic>();
  final _sensorsList = List<Sensor>();
  bool isAppTerminated = true;
  AppState appState = AppState.NEW_INSTANCE;

  final sensorsStateSubject = PublishSubject<SensorsState>();
  final chartStateSubject = PublishSubject<SensorsState>();

  @override
  void dispatch(SensorsEvent event) async {
    if (event is SensorsDataRequested) {
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
        getSensorsList(_nodesList);
        print('NODES SIZE = ${_nodesList.length}');

        sensorsStateSubject.add(SensorsDataAreFetched(_sensorsList));
        chartStateSubject.add(SensorsDataAreFetched(_sensorsList));
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void getSensorsList(List<dynamic> nodes) {
    _sensorsList.clear();
    for (var node in nodes) {
      _sensorsList.add(Sensor("Ramp", node.toString()));
    }
  }

  void dispose() {
    sensorsStateSubject.close();
    chartStateSubject.close();
  }
}

enum AppState {
  ACTIVE,
  NEW_INSTANCE
}
