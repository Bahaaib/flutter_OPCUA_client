import 'package:ocpua_app/PODO/Sensor.dart';

abstract class SensorsState{}

class SensorsDataAreFetched extends SensorsState{
  final List<Sensor> sensorsList;

  SensorsDataAreFetched(this.sensorsList);


}