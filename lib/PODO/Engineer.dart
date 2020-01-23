import 'package:json_annotation/json_annotation.dart';

part 'Engineer.g.dart';


@JsonSerializable()
class Engineer{
  int id;
  String name;
  String email;
  List lines;

  Engineer(
    this.id,
    this.name,
    this.email,
    this.lines,
  );

  factory Engineer.fromJson(Map<String, dynamic> json) => _$EngineerFromJson(json);

  Map<String, dynamic> toJson() => _$EngineerToJson(this);
}