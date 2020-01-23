import 'package:json_annotation/json_annotation.dart';

part 'Sensor.g.dart';

@JsonSerializable()
class Sensor {
  String sensorId;
  String value;

  Sensor(this.sensorId, this.value);

  factory Sensor.fromJson(Map<String, dynamic> json) => _$SensorFromJson(json);

  Map<String, dynamic> toJson() => _$SensorToJson(this);
}
