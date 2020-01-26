import 'package:json_annotation/json_annotation.dart';
import 'package:ocpua_app/PODO/Signal.dart';
import 'package:ocpua_app/support/Fly/fly.dart';
part 'Line.g.dart';

@JsonSerializable()
class Line implements Parser<Line>{
  String ip;
  String name;
  List<Signal> signals;

  Line({this.name, this.ip, this.signals});
  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);

  Line.empty();

  @override
  List<String> querys;

  @override
  dynamicParse(data) {
    // TODO: implement dynamicParse
    return null;
  }

  @override
  Line parse(data) {
    return Line.fromJson({"productionLines": data});
  }
}
