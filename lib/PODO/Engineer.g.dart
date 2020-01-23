// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Engineer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Engineer _$EngineerFromJson(Map<String, dynamic> json) {
  return Engineer(
    json['id'] as int,
    json['name'] as String,
    json['email'] as String,
    json['lines'] as List,
  );
}

Map<String, dynamic> _$EngineerToJson(Engineer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'lines': instance.lines,
    };
