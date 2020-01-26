// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Clients.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clients _$ClientsFromJson(Map<String, dynamic> json) {
  return Clients(
    (json['clientsList'] as List)
        ?.map((e) =>
            e == null ? null : Client.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..querys = (json['querys'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$ClientsToJson(Clients instance) => <String, dynamic>{
      'clientsList': instance.clientsList,
      'querys': instance.querys,
    };
