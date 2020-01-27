import 'package:json_annotation/json_annotation.dart';
import 'package:ocpua_app/support/Fly/fly.dart';

part 'Signal.g.dart';

@JsonSerializable()
class Signal implements Parser<Signal>{
  String node_index;
  String value;


  Signal(this.node_index, this.value);

  factory Signal.fromJson(Map<String, dynamic> json) => _$SignalFromJson(json);

  Signal.empty();

  @override
  List<String> querys;

  @override
  dynamicParse(data) {
    // TODO: implement dynamicParse
    return null;
  }

  @override
  Signal parse(data) {
    return Signal.fromJson({"signals": data});
  }
}

