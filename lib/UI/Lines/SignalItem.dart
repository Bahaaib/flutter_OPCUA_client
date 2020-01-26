import 'package:flutter/material.dart';
import 'package:ocpua_app/PODO/Signal.dart';
import 'package:ocpua_app/UI/Lines/chart.dart';
import 'package:ocpua_app/UI/Lines/signalDetails.dart';

class SignalItem extends StatefulWidget {
  const SignalItem({this.signal, this.index});

  final Signal signal;
  final int index;

  @override
  _SignalItemState createState() => _SignalItemState();
}

class _SignalItemState extends State<SignalItem> {
  List<LinearData> data = new List<LinearData>();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SignalDetails(
                index: widget.index,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 10,
        ),
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 0.3,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(3),
          ),
        ),
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                '${widget.signal.node_index}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              Text(
                '${widget.signal.node_index}',
                style: TextStyle(color: Colors.green, fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
