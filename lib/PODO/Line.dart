import 'package:json_annotation/json_annotation.dart';
import 'package:ocpua_app/PODO/Sensor.dart';

part 'Line.g.dart';

@JsonSerializable()
class Line {
  int id;
  String endPoint;
  String name;
  List<Sensor> sensors;

  Line(
    this.id,
    this.endPoint,
    this.name,
    this.sensors,
  );

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);

  Map<String, dynamic> toJson() => _$LineToJson(this);
}