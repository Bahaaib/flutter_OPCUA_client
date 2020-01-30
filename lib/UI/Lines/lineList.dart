import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ocpua_app/PODO/Line.dart';
import 'package:ocpua_app/UI/Lines/lineItem.dart';
import 'package:ocpua_app/bloc/line/bloc.dart';
import 'package:ocpua_app/bloc/signals/bloc.dart';
import 'package:ocpua_app/resources/string.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LineList extends StatefulWidget {
  @override
  _LineListState createState() => _LineListState();
}

class _LineListState extends State<LineList> {
  List<Line> linesList = List<Line>();
  final LineBloc _linesBloc = GetIt.instance<LineBloc>();
  final SignalsBloc _signalsBloc = GetIt.instance<SignalsBloc>();
  bool _isLoading = false;
  bool _isTimedOut = false;
  bool _isNotResponding = true;
  String _timeoutMessage = '';
  ProgressDialog _progressDialog;

  void initState() {
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _progressDialog.show());

    _linesBloc.linesStateSubject.listen((receivedState) {
      if (receivedState is LinesAreFetched) {
        setState(() {
          _isLoading = false;
          _isNotResponding = false;
          linesList = receivedState.linesList;
        });

        if (_progressDialog.isShowing() && !_isLoading) {
          _progressDialog.dismiss();
        }
      }
    });
    _linesBloc.dispatch(LinesRequested());

    super.initState();
  }

  void _initProgressDialog() {
    _progressDialog.style(
      message: 'Collecting Client Data...',
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
    );
  }

  Future<void> _launchTimeoutCounter(BuildContext context) async {
    Future.delayed(Duration(seconds: 10)).then((_) {
      _progressDialog.dismiss();
      setState(() {
        _timeoutMessage =
            'No Lines Listed for your account yet. Please contact system admin for further assistance';
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

  @override
  Widget build(BuildContext context) {
    _progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    _initProgressDialog();
    if (!_isTimedOut) {
      _launchTimeoutCounter(context);
      _isTimedOut = true;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text('Welcome'),
        centerTitle: true,
      ),
      body: linesList.isNotEmpty
          ? Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 20),
                      itemCount: linesList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return LineItem(line: linesList[i]);
                      }),
                ),
                logoutButton(),
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
                Text(
                  _timeoutMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
    );
  }

  Widget logoutButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
      height: 55,
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/signIn', (r) => false);
        },
        color: Colors.red,
        child: Text(
          AppStrings.logout,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
