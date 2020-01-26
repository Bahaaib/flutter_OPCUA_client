import 'package:ocpua_app/PODO/Signal.dart';

abstract class SignalsState{}

class SignalsDataAreFetched extends SignalsState{
  final List<Signal> signalsList;

  SignalsDataAreFetched(this.signalsList);


}