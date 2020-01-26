import 'package:json_annotation/json_annotation.dart';
import 'package:ocpua_app/PODO/Client.dart';
import 'package:ocpua_app/PODO/Line.dart';
import 'package:ocpua_app/support/Fly/fly.dart';

part 'Clients.g.dart';

@JsonSerializable()
class Clients implements Parser<Clients> {
  List<Client> clientsList;


  Clients(this.clientsList);

  factory Clients.fromJson(Map<String, dynamic> json) =>
      _$ClientsFromJson(json);

  Clients.empty();

  Clients parse(data) {
    return Clients.fromJson({"clientsList": data});
  }

  @override
  List<String> querys;

  @override
  dynamicParse(data) {
    // TODO: implement dynamicParse
    return null;
  }
}