// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medication _$MedicationFromJson(Map<String, dynamic> json) => Medication()
  ..uuid = json['uuid'] as String
  ..name = json['name'] as String?
  ..enabled = json['enabled'] as bool
  ..frequency = Frequency.fromJson(json['frequency'] as Map<String, dynamic>);

Map<String, dynamic> _$MedicationToJson(Medication instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'enabled': instance.enabled,
      'frequency': instance.frequency,
    };

Frequency _$FrequencyFromJson(Map<String, dynamic> json) => Frequency()
  ..timesOfDay = (json['timesOfDay'] as List<dynamic>)
      .map((e) => MedicationTime.fromJson(e as Map<String, dynamic>))
      .toList()
  ..daysOfWeek =
      (json['daysOfWeek'] as List<dynamic>?)?.map((e) => e as int).toList()
  ..daysBetween = json['daysBetween'] as int?
  ..startDate = json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String)
  ..endDate =
      json['endDate'] == null ? null : DateTime.parse(json['endDate'] as String)
  ..hasEndDate = json['hasEndDate'] as bool;

Map<String, dynamic> _$FrequencyToJson(Frequency instance) => <String, dynamic>{
      'timesOfDay': instance.timesOfDay,
      'daysOfWeek': instance.daysOfWeek,
      'daysBetween': instance.daysBetween,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'hasEndDate': instance.hasEndDate,
    };

MedicationTime _$MedicationTimeFromJson(Map<String, dynamic> json) =>
    MedicationTime()
      ..hour = json['hour'] as int
      ..minute = json['minute'] as int;

Map<String, dynamic> _$MedicationTimeToJson(MedicationTime instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
    };
