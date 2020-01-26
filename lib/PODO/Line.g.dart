// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Line _$LineFromJson(Map<String, dynamic> json) {
  return Line(
    name: json['name'] as String,
    ip: json['ip'] as String,
  )..querys = (json['querys'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$LineToJson(Line instance) => <String, dynamic>{
      'ip': instance.ip,
      'name': instance.name,
      'querys': instance.querys,
    };
