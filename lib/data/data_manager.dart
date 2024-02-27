import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tsa_software_2024/data/config/globals.dart';

import 'medication/medication.dart';

part 'data_manager.g.dart';

@JsonSerializable()
class AppData {
  AppData();
  List<Medication> medications = [];
  GlobalConfig config = GlobalConfig();

  void addMedication(Medication medication) {
    medications.removeWhere((element) => element.uuid == medication.uuid);
    medications.add(medication);
    saveAppData(this);
  }

  factory AppData.fromJson(Map<String, dynamic> json) => _$AppDataFromJson(json);
  Map<String, dynamic> toJson() => _$AppDataToJson(this);
}

Future<AppData> getAppData() async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  try {
    var file = File("${directory.path}/app.data");
    if (!await file.exists()) {
      var data = AppData();
      saveAppData(data);
      return data;
    }
    final json = await file.readAsString();
    return AppData.fromJson(jsonDecode(json) as Map<String, dynamic>);
  } catch (e) {
    print("could not open appdata");
    print(e);
    return AppData();
  }
}

void saveAppData(AppData appData) async {
  appData.medications.sort((a, b) => a.name!.compareTo(b.name!));

  final directory = await getApplicationDocumentsDirectory();
  try {
    var file = File("${directory.path}/app.data");
    file.writeAsString(jsonEncode(appData.toJson()));
  } catch (e) {
    print("could not save appdata");
    print(e);
  }
}