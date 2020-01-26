// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Signal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Signal _$SignalFromJson(Map<String, dynamic> json) {
  return Signal(
    json['node_index'] as String,
  )..querys = (json['querys'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$SignalToJson(Signal instance) => <String, dynamic>{
      'node_index': instance.node_index,
      'querys': instance.querys,
    };
