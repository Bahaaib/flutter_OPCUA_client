import 'package:flutter/material.dart';
import 'package:ocpua_app/PODO/Line.dart';
import 'package:ocpua_app/UI/Lines/sensorList.dart';


class LineItem extends StatefulWidget {
  const LineItem({this.line});

  final Line line;

  @override
  _LineItemState createState() => _LineItemState();
}

class _LineItemState extends State<LineItem> {
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SensorList(
                line: widget.line,
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
            )),
        child: Center(
          child: Text(widget.line.name),
        ),
      ),
    );
  }
}
