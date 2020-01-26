// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Lines.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lines _$LinesFromJson(Map<String, dynamic> json) {
  return Lines(
    (json['linesList'] as List)
        ?.map(
            (e) => e == null ? null : Line.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..querys = (json['querys'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$LinesToJson(Lines instance) => <String, dynamic>{
      'linesList': instance.linesList,
      'querys': instance.querys,
    };
