// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OCRResponse _$OCRResponseFromJson(Map<String, dynamic> json) => OCRResponse(
      medication: json['medication'] as String,
      condition: json['condition'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$OCRResponseToJson(OCRResponse instance) =>
    <String, dynamic>{
      'medication': instance.medication,
      'condition': instance.condition,
      'imageUrl': instance.imageUrl,
    };
