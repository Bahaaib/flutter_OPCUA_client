// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Line _$LineFromJson(Map<String, dynamic> json) {
  return Line(
    json['id'] as int,
    json['endPoint'] as String,
    json['name'] as String,
    (json['sensors'] as List)
        ?.map((e) =>
            e == null ? null : Sensor.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LineToJson(Line instance) => <String, dynamic>{
      'id': instance.id,
      'endPoint': instance.endPoint,
      'name': instance.name,
      'sensors': instance.sensors,
    };
