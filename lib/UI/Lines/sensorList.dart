import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ocpua_app/PODO/Line.dart';
import 'package:ocpua_app/PODO/Sensor.dart';
import 'package:ocpua_app/UI/Lines/sensorItem.dart';
import 'package:ocpua_app/bloc/sensors/bloc.dart';

class SensorList extends StatefulWidget {
  const SensorList({this.line});

  final Line line;

  @override
  _SensorListState createState() => _SensorListState();
}

class _SensorListState extends State<SensorList> {
  final _sensorsBloc = SensorsBloc.instance();
  final _sensorsList = List<Sensor>();
  bool _isLoading = false;

  @override
  void initState() {
    print('SensorList --> initState()');
    _isLoading = true;
    _sensorsBloc.sensorsStateSubject.listen((receivedState) {
      if (receivedState is SensorsDataAreFetched) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _sensorsList.clear();
            _sensorsList.addAll(receivedState.sensorsList);
            print('SENSORS SIZE = ${_sensorsList.length}');
          });
        }
      }
    });

    //Only launch session if a new instance of the app created
    if (_sensorsBloc.appState == AppState.NEW_INSTANCE) {
      print('NEW INSTANCE');
      _sensorsBloc.dispatch(SensorsDataRequested());
      _sensorsBloc.appState = AppState.ACTIVE;
    } else {
      print('APP IS ACTIVE');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Testing Line'),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 20),
                  itemCount:
                      _sensorsList.length != null ? _sensorsList.length : 0,
                  itemBuilder: (BuildContext context, int position) {
                    return SensorItem(
                      sensor: _sensorsList[position],
                      index: position,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
