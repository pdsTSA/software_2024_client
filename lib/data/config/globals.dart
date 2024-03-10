import 'package:json_annotation/json_annotation.dart';

part 'globals.g.dart';

const APP_NAME = "PillMate";

//TODO: find other stuff to put in here
@JsonSerializable()
class GlobalConfig {
  GlobalConfig();

  String apiUrl = '';

  factory GlobalConfig.fromJson(Map<String, dynamic> json) => _$GlobalConfigFromJson(json);
  Map<String, dynamic> toJson() => _$GlobalConfigToJson(this);
}