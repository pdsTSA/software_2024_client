// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalContact _$MedicalContactFromJson(Map<String, dynamic> json) =>
    MedicalContact(
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
    )..uuid = json['uuid'] as String;

Map<String, dynamic> _$MedicalContactToJson(MedicalContact instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
    };
