import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
  bool _isTerminationRequested = false;
  bool _isTimedOut = false;
  bool _isNotResponding = true;
  String _timeoutMessage = '';
  ProgressDialog _progressDialog;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _progressDialog.show());
    print('SignalsList --> initState()');
    _isLoading = true;
    _signalsBloc.signalsStateSubject.listen((receivedState) {
      if (receivedState is SignalsDataAreFetched) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isNotResponding = false;
            _signalsList.clear();
            _signalsList.addAll(receivedState.signalsList);
            print('SIGNALS SIZE = ${_signalsList.length}');
          });

          if (_progressDialog.isShowing() &&
              !_isLoading &&
              !_isTerminationRequested) {
            _progressDialog.dismiss();
          }
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

  void _initProgressDialog({@required String message}) {
    _progressDialog.style(
      message: message,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    _initProgressDialog(message: 'Connecting OPCUA Server...');
    if (!_isTimedOut) {
      _launchTimeoutCounter(context);
      _isTimedOut = true;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('${widget.line.name}'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () async => await _terminateSession(context),
        ),
      ),
      body: _signalsList.isNotEmpty
          ? Column(
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
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.warning,
                  size: 50.0,
                  color:
                      _timeoutMessage.isNotEmpty ? Colors.grey : Colors.white,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    _timeoutMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _launchTimeoutCounter(BuildContext context) async {
    Future.delayed(Duration(seconds: 10)).then((_) {
      _progressDialog.dismiss();
      setState(() {
        _timeoutMessage =
            'No Signals Listed for this line yet. Please contact system admin for further assistance';
      });
      if (_isNotResponding) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Container(
              height: 100.0,
              child: Center(
                child: Text('Connection Timeout'),
              ),
            ),
            title: Container(
              height: 50.0,
              color: Colors.red,
              child: Center(
                child: Text(
                  'Error',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            titlePadding: EdgeInsets.all(0.0),
          ),
        );
      }
    });
  }

  Future<void> _terminateSession(BuildContext context) async {
    _initProgressDialog(message: 'Closing Session...');
    _progressDialog.show();
    _isTerminationRequested = true;
    _signalsBloc.dispatch(SessionTerminationRequested());
    Future.delayed(Duration(seconds: 4)).then((_) {
      _progressDialog.dismiss();
      Navigator.of(context).pop();
    });
  }
}
