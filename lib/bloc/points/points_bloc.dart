import 'dart:math';

import 'package:ocpua_app/UI/Lines/chart.dart';
import 'package:ocpua_app/bloc/bloc.dart';
import 'package:ocpua_app/bloc/points/points_event.dart';
import 'package:ocpua_app/bloc/points/points_state.dart';
import 'package:rxdart/rxdart.dart';


class PointsBloc extends BLoC<PointsEvent> {
  static PointsBloc _pointsBloc;

  static PointsBloc instance() {
    if (_pointsBloc == null) {
      _pointsBloc = PointsBloc._();
    }
    return _pointsBloc;
  }

  PointsBloc._();
  PublishSubject<PointsState> pointStateSubject = PublishSubject();
  List<LinearData> points = new List<LinearData>();

  var x = 0;
  var y = new Random();
  var one = true;

  @override
  void dispatch(PointsEvent event) {
    if (event is FetchPoints) {
      _fetchPoints();
    }

    if (event is AddPoint) {
      _addPoint();
    }
  }

  _fetchPoints() {
    var one = new LinearData(0, 0);
    points.add(one);
    pointStateSubject.sink.add(PointsFetched(points));
  }

  _addPoint() {
    var point = new LinearData(x, y.nextInt(100));
    x += 1;
    pointStateSubject.sink.add(PointsAdded(point));
  }

  dispose() {
    pointStateSubject.close();
    _pointsBloc = null;
  }
}
