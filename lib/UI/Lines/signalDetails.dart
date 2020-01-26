import 'dart:async';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:ocpua_app/PODO/Signal.dart';
import 'package:ocpua_app/UI/Lines/chart.dart';
import 'package:ocpua_app/bloc/signals/signals_bloc.dart';
import 'package:ocpua_app/bloc/signals/signals_event.dart';
import 'package:ocpua_app/bloc/signals/signals_state.dart';


class SignalDetails extends StatefulWidget {
  const SignalDetails({this.index});

  final int index;

  @override
  _SignalDetailsState createState() => _SignalDetailsState();
}

class _SignalDetailsState extends State<SignalDetails> {
  final _signalsBloc = SignalsBloc.instance();
  Signal _signal;
  final _data = List<LinearData>();
  Timer _timer;
  int _secondsElapsed = 0;
  String _nonNumericData = '';

  void initState() {
    _launchSecondsTimer();
    _signalsBloc.chartStateSubject.listen((receivedState) {
      if (receivedState is SignalsDataAreFetched) {
        if (mounted) {
          setState(() {
            _signal = receivedState.signalsList[widget.index];
            _data.add(
                LinearData(_secondsElapsed, _getEvaluatedData(_signal.value)));
          });
        }
      }
    });
    _signalsBloc.dispatch(ChartDataRequested());
    super.initState();
  }

  int _getEvaluatedData(String value) {
    if (_isNumeric(value)) {
      return double.parse(value).toInt();
    } else {
      _nonNumericData = value;
      return 0;
    }
  }

  bool _isNumeric(String value) {
    if (value == null) {
      return false;
    } else {
      return double.tryParse(value) != null;
    }
  }

  void _launchSecondsTimer() {
    _timer = Timer.periodic(
      Duration(milliseconds: 1000),
      (Timer t) => _secondsElapsed++,
    );
  }

  List<charts.Series<LinearData, int>> _createSampleData() {
    return [
      new charts.Series<LinearData, int>(
        id: 'signals',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearData data, _) => data.xAxis,
        measureFn: (LinearData data, _) => data.yAxis,
        data: _data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              print("Page is Back");
              Navigator.pop(context, true);
            }),
        backgroundColor: Colors.red,
        title: Text('Test Signal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            _nonNumericData.isEmpty
                ? Center(
                    child: Text(
                      _data.length != 0 ? _data.last.yAxis.toString() : '0',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 150,
            ),
            _nonNumericData.isEmpty
                ? Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: 200,
                    child: SimpleLineChart(_createSampleData()),
                  )
                : Center(
                    child: Text(
                      _nonNumericData,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
