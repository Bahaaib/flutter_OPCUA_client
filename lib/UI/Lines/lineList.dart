import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ocpua_app/PODO/Line.dart';
import 'package:ocpua_app/UI/Lines/lineItem.dart';
import 'package:ocpua_app/bloc/line/bloc.dart';
import 'package:ocpua_app/bloc/signals/bloc.dart';
import 'package:ocpua_app/resources/string.dart';

class LineList extends StatefulWidget {
  @override
  _LineListState createState() => _LineListState();
}

class _LineListState extends State<LineList> {
  List<Line> linesList = List<Line>();
  final LineBloc _linesBloc = GetIt.instance<LineBloc>();
  final SignalsBloc _signalsBloc = GetIt.instance<SignalsBloc>();

  void initState() {
    _linesBloc.linesStateSubject.listen((receivedState) {
      if (receivedState is LinesAreFetched) {
        setState(() {
          linesList = receivedState.linesList;
        });
      }
    });
    _linesBloc.dispatch(LinesRequested());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text('Welcome'),
        centerTitle: true,
      ),
      body: Column(
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
