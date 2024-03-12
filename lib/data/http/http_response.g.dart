// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OCRResponse _$OCRResponseFromJson(Map<String, dynamic> json) => OCRResponse(
      drug: json['drug'] as String,
      condition: json['condition'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$OCRResponseToJson(OCRResponse instance) =>
    <String, dynamic>{
      'drug': instance.drug,
      'condition': instance.condition,
      'image': instance.image,
    };
