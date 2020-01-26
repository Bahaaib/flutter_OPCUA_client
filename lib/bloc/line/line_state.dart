import 'package:ocpua_app/PODO/Line.dart';

abstract class LineState{}

class LinesAreFetched extends LineState{
  final List<Line> linesList;

  LinesAreFetched(this.linesList);
}