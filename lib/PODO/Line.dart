import 'package:json_annotation/json_annotation.dart';
import 'package:ocpua_app/PODO/Sensor.dart';

part 'Line.g.dart';

@JsonSerializable()
class Line {
  String ip;
  String name;

  Line(this.ip, this.name);

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);

  Map<String, dynamic> toJson() => _$LineToJson(this);
}