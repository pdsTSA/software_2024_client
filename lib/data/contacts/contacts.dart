import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'contacts.g.dart';

var uuidgen = const Uuid();

@JsonSerializable()
class MedicalContact{
  String uuid = uuidgen.v4();
  String name;
  String phone;
  String email;
  String address;

  MedicalContact({
    required this.name,
    required this.phone,
    required this.email,
    required this.address
  });
  
  factory MedicalContact.fromJson(Map<String, dynamic> json) => _$MedicalContactFromJson(json);
  Map<String, dynamic> toJson() => _$MedicalContactToJson(this);
}