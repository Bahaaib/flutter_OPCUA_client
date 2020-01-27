// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Signal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Signal _$SignalFromJson(Map<String, dynamic> json) {
  return Signal(
    json['node_index'] as String,
    json['value'] as String,
  )..querys = (json['querys'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$SignalToJson(Signal instance) => <String, dynamic>{
      'node_index': instance.node_index,
      'value': instance.value,
      'querys': instance.querys,
    };
