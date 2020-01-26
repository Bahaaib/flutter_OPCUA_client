import 'package:ocpua_app/PODO/Lines.dart';

abstract class LineState{}

class LinesAreFetched extends LineState{
  final Lines lines;

  LinesAreFetched(this.lines);
}