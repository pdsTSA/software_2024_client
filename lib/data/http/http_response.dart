import 'package:json_annotation/json_annotation.dart';

part 'http_response.g.dart';

@JsonSerializable()
class OCRResponse {
  OCRResponse({required this.medication, required this.condition, required this.imageUrl});

  String medication;
  String condition;
  String imageUrl;

  factory OCRResponse.fromJson(Map<String, dynamic> json) => _$OCRResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OCRResponseToJson(this);
}