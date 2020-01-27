import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ocpua_app/PODO/Line.dart';
import 'package:ocpua_app/PODO/Signal.dart';
import 'package:ocpua_app/UI/Lines/SignalItem.dart';
import 'package:ocpua_app/bloc/signals/bloc.dart';
import 'package:ocpua_app/bloc/signals/signals_bloc.dart';
import 'package:ocpua_app/bloc/signals/signals_state.dart';

class SignalList extends StatefulWidget {
  const SignalList({this.line});

  final Line line;

  @override
  _SignalListState createState() => _SignalListState();
}

class _SignalListState extends State<SignalList> {
  final _signalsBloc = GetIt.instance<SignalsBloc>();
  final _signalsList = List<Signal>();
  bool _isLoading = false;

  @override
  void initState() {
    print('SignalsList --> initState()');
    _isLoading = true;
    _signalsBloc.signalsStateSubject.listen((receivedState) {
      if (receivedState is SignalsDataAreFetched) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _signalsList.clear();
            _signalsList.addAll(receivedState.signalsList);
            print('SIGNALS SIZE = ${_signalsList.length}');
          });
        }
      }
    });

    //Only launch session if a new instance of the app created
    if (_signalsBloc.appState == AppState.NEW_INSTANCE ||
        _signalsBloc.sessionStatus == 'TERMINATED') {
      print('NEW INSTANCE');
      _signalsBloc.sessionStatus = 'RUNNING';
      _signalsBloc
          .dispatch(SignalsDataRequested(widget.line.signals, widget.line.ip));
      _signalsBloc.appState = AppState.ACTIVE;
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
        title: Text('${widget.line.name}'),
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
                      _signalsList.length != null ? _signalsList.length : 0,
                  itemBuilder: (BuildContext context, int position) {
                    return SignalItem(
                      signal: _signalsList[position],
                      index: position,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('DISPOSED');
    _signalsBloc.dispatch(SessionTerminationRequested());
    super.dispose();
  }
}
