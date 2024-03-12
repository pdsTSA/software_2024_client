import 'package:json_annotation/json_annotation.dart';

part 'http_response.g.dart';

@JsonSerializable()
class OCRResponse {
  OCRResponse({required this.drug, required this.condition, required this.image});

  String drug;
  String condition;
  String image;

  factory OCRResponse.fromJson(Map<String, dynamic> json) => _$OCRResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OCRResponseToJson(this);
}