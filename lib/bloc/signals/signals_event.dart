import 'package:ocpua_app/PODO/Signal.dart';

abstract class SignalsEvent{}

class SignalsDataRequested extends SignalsEvent{
  final List<Signal> requestedSignals;
  final String ip;

  SignalsDataRequested(this.requestedSignals, this.ip);

}

class ChartDataRequested extends SignalsEvent{}