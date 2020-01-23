import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleLineChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleLineChart(this.seriesList, {this.animate});

  @override
  _SimpleLineChartState createState() => _SimpleLineChartState();
}

class _SimpleLineChartState extends State<SimpleLineChart> {
  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(widget.seriesList, animate: widget.animate);
  }
}

/// Sample linear data type.
class LinearData {
  final dynamic xAxis;
  final dynamic yAxis;

  LinearData(
    this.xAxis,
    this.yAxis,
  );
}
