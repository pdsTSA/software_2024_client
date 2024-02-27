// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppData _$AppDataFromJson(Map<String, dynamic> json) => AppData()
  ..medications = (json['medications'] as List<dynamic>)
      .map((e) => Medication.fromJson(e as Map<String, dynamic>))
      .toList()
  ..config = GlobalConfig.fromJson(json['config'] as Map<String, dynamic>);

Map<String, dynamic> _$AppDataToJson(AppData instance) => <String, dynamic>{
      'medications': instance.medications,
      'config': instance.config,
    };
