import 'package:json_annotation/json_annotation.dart';
import 'package:ocpua_app/PODO/Line.dart';
import 'package:ocpua_app/support/Fly/fly.dart';

part 'Client.g.dart';

@JsonSerializable()
class Client implements Parser<Client> {
  String name;
  List<Line> productionLines;

  Client(this.name, this.productionLines);

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  Client.empty();

  Client parse(data) {
    return Client.fromJson({"Client": data});
  }

  @override
  List<String> querys;

  @override
  dynamicParse(data) {
    // TODO: implement dynamicParse
    return null;
  }
}
