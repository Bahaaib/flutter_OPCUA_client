// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Sensor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sensor _$SensorFromJson(Map<String, dynamic> json) {
  return Sensor(
    json['sensorId'] as String,
    json['value'] as String,
  );
}

Map<String, dynamic> _$SensorToJson(Sensor instance) => <String, dynamic>{
      'sensorId': instance.sensorId,
      'value': instance.value,
    };
