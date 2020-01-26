import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:ocpua_app/PODO/Client.dart';
import 'package:ocpua_app/PODO/Line.dart';
import 'package:ocpua_app/bloc/bloc.dart';
import 'package:ocpua_app/bloc/line/bloc.dart';
import 'package:ocpua_app/support/Fly/fly.dart';
import 'package:ocpua_app/support/GraphClient/GrapghQlBuilder.dart';
import 'package:rxdart/rxdart.dart';

class LineBloc extends BLoC<LineEvent> {
  final linesStateSubject = BehaviorSubject<LineState>();
  final Fly _fly = GetIt.instance<Fly>();
  Node _clientQuery;

  @override
  void dispatch(LineEvent event) async {
    if (event is LinesRequested) {
      _initLineQuery();
      await _getProductionLines();
    }
  }

  void _initLineQuery() {
    _clientQuery = Node(name: 'Client', args: {
      'id': 3
    }, cols: [
      'name',
      Node(name: "productionLines", args: {}, cols: [
        'name',
        'ip',
        Node(name: 'signals', args: {}, cols: ['node_index'])
      ])
    ]);
  }

  Future<void> _getProductionLines() async {
    dynamic results =
        await _fly.query([_clientQuery], parsers: {'Client': Client.empty()});

    print('RESULTS = $results');
    Client _client = results['Client'];
    print('CLIENTS = ${results['Client']}');

    List<Line> _lines = _client.productionLines;
    print('LINES COUNT = ${_lines.length}');
    print('SIGNALS COUNT = ${_lines[0].signals.length}');

    linesStateSubject.sink.add(LinesAreFetched(_lines));
  }

  void dispose() {
    linesStateSubject.close();
  }
}
