
import 'package:flutter/material.dart';
import 'package:ocpua_app/PODO/Line.dart';
import 'package:ocpua_app/PODO/Sensor.dart';
import 'package:ocpua_app/UI/Lines/lineItem.dart';
import 'package:ocpua_app/resources/string.dart';


class LineList extends StatefulWidget {
  @override
  _LineListState createState() => _LineListState();
}

class _LineListState extends State<LineList> {
  List<Line> linesList = List<Line>();

  void initState() {
    final _sensor1 = Sensor("Simulation Examples.Functions.Ramp1", "");
    final _sensor2 = Sensor("Simulation Examples.Functions.Ramp2", "");

    final _line1 = Line(1, '1', 'Line One', [_sensor1]);
    final _line2 = Line(2, '2', 'Line Two', [_sensor2]);

    linesList.add(_line1);
    linesList.add(_line2);
    linesList.add(_line1);
    linesList.add(_line2);
    linesList.add(_line1);
    linesList.add(_line2);
    linesList.add(_line1);

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
                  return LineItem(line: linesList.elementAt(i));
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
