import 'package:json_annotation/json_annotation.dart';
import 'package:ocpua_app/PODO/Line.dart';
import 'package:ocpua_app/support/Fly/fly.dart';

part 'Lines.g.dart';

@JsonSerializable()
class Lines implements Parser<Lines> {
  List<Line> linesList;

  Lines(this.linesList);

  factory Lines.fromJson(Map<String, dynamic> json) =>
      _$LinesFromJson(json);

  Lines.empty();

  Lines parse(data) {
    return Lines.fromJson({"linesList": data});
  }

  @override
  List<String> querys;

  @override
  dynamicParse(data) {
    // TODO: implement dynamicParse
    return null;
  }
}