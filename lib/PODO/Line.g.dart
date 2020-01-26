// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Line _$LineFromJson(Map<String, dynamic> json) {
  return Line(
    name: json['name'] as String,
    ip: json['ip'] as String,
    signals: (json['signals'] as List)
        ?.map((e) =>
            e == null ? null : Signal.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..querys = (json['querys'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$LineToJson(Line instance) => <String, dynamic>{
      'ip': instance.ip,
      'name': instance.name,
      'signals': instance.signals,
      'querys': instance.querys,
    };
