import 'package:flutter/material.dart';
import 'package:ocpua_app/PODO/Sensor.dart';
import 'package:ocpua_app/UI/Lines/chart.dart';
import 'package:ocpua_app/UI/Lines/sensorDetails.dart';

class SensorItem extends StatefulWidget {
  const SensorItem({this.sensor, this.index});

  final Sensor sensor;
  final int index;

  @override
  _SensorItemState createState() => _SensorItemState();
}

class _SensorItemState extends State<SensorItem> {
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
              return SensorDetails(
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
                '${widget.sensor.sensorId}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              Text(
                '${widget.sensor.value}',
                style: TextStyle(color: Colors.green, fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
